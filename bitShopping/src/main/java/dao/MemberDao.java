package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import bean.CheckBean;
import bean.Member;
import shopping.ShoppingInfo;


@Component("mdao")
public class MemberDao {

	private final String namespace = "MapMember" ;	
	
	@Autowired
	SqlSessionTemplate abcd;
	
	public MemberDao() {	}
	
	
	public int InsertData(Member member) {
		return this.abcd.insert(namespace + ".InsertData", member);
	}

	public List<CheckBean> GetList(String module, String field, String kind) {		
		// 체크 박스, 라디오 버튼, 콤보 박스의 내용들을 가져옵니다.
		System.out.println(module);
		System.out.println(field);
		System.out.println(kind);
		
		Map<String, String> map = new HashMap<String, String>() ;
		map.put("module", module) ;
		map.put("field", field) ;
		map.put("kind", kind) ;
		return this.abcd.selectList(namespace + ".GetList", map);	
	}

	public Member SelectDataByPk(String mid) {
		return this.abcd.selectOne(namespace + ".SelectDataByPk", mid);
	}

	public List<Member> SelectDataList(int offset, int limit, String mode, String keyword) {
		// 랭킹을 이용하여 해당 페이지의 데이터를 컬렉션으로 반환 해 줍니다.
		RowBounds rowBounds = new RowBounds(offset, limit);
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("mode", mode);
		map.put("keyword", "%" + keyword + "%"); // 키워드를 포함하는
		return this.abcd.selectList(namespace + ".SelectDataList", map, rowBounds);
	}


	public int SelectTotalCount(String mode, String keyword) {
		// 파라미터 mode와 keyword를 이용하여 총 회원 수를 구합니다.
		Map<String, String> map = new HashMap<String, String>();
		map.put("mode", mode);
		map.put("keyword", "%" + keyword + "%"); // 키워드를 포함하는
		return this.abcd.selectOne(namespace + ".SelectTotalCount" , map);
	}

	public int DeleteData(Member bean) {
		// orders.remark 수정
		// 해당 id를 이용하여 회원 탈퇴를 수행합니다.		
						
		// 탈퇴할 회원이 남긴 정보의 remark 컬럼 정보를 수정합니다.
		Map<String, String> map = new HashMap<String, String>();
		String remark = bean.getName() + "(" + bean.getMid() + ")님이 회원탈퇴를 하셨습니다.";
		
		map.put("bwriter", bean.getMid()) ;		
		
		// orders.remark 수정
		map.clear();
		map.put("remark", remark);
		map.put("mid", bean.getMid());
		System.out.println("bean.getMid()" + bean.getMid());
		System.out.println("delete : " + map);
		this.abcd.update(namespace + ".UpdateOrderRemark" , map);
		
		return this.abcd.delete(namespace + ".DeleteData" , bean.getMid());
	}


	public List<ShoppingInfo> getShoppingInfo(String mid) {
		
		return this.abcd.selectList(namespace+".SelectShoppingInfo", mid);
	}


	public void InsertCartData(Member mem, List<ShoppingInfo> lists) {
		// 1. 장바구니 테이블에 혹시 남아 있을 수 있는 회원의 행을 모두 삭제합니다. 
		this.abcd.delete(namespace + ".DeleteShoppingInfo", mem.getMid());
		
		// 2.반복문을 사용하여 테이블에 인서트 합니다.
		for(ShoppingInfo shpInfo : lists){
			this.abcd.insert(namespace + ".InsertShoppingInfo", shpInfo);
		}
	}


	public int UpdateData(Member member) {
		return this.abcd.update(namespace + ".UpdateData", member);
	}


	
}

package kr.happyjob.chainmaker.epc.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.chainmaker.epc.dao.ProductListDAO;
import kr.happyjob.chainmaker.epc.model.ProductListModel;
import kr.happyjob.chainmaker.scm.model.ProductInfoModel;


@Service
public class ProductListServiceImpl implements ProductListService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	ProductListDAO productListDao;
	
	/** 그룹코드 목록 조회 */
	public List<ProductListModel> listProductList(Map<String, Object> paramMap) throws Exception {
		
		List<ProductListModel> listProductList = productListDao.listProductList(paramMap);
		
		return listProductList;
	}
	
	/** 그룹코드 목록 카운트 조회 */
	public int countListProductList(Map<String, Object> paramMap) throws Exception {
		
		int totalCount = productListDao.countListProductList(paramMap);
		
		return totalCount;
	}
	
	/** 모달창 조회 **/
	@Override
	public ProductListModel selectProductDetail(Map<String, Object> paramMap) {
		ProductListModel detail = productListDao.selectProductDetail(paramMap);
		return detail;
	}
	
	/** 주문기능*/
	public int insertOrder(Map<String, Object> paramMap) throws Exception {
		
		int order = productListDao.insertOrder(paramMap);
		
		return order;
	}
	
	/** 장바구니기능*/
	public int insertBasket(Map<String, Object> paramMap) throws Exception {
		
		int order = productListDao.insertBasket(paramMap);
		
		return order;
	}
	
	/** 동적 셀렉트 조회 */
	public List<ProductListModel> selectProduct(Map<String, Object> paramMap) throws Exception {
		
		List<ProductListModel> selProduct = productListDao.selectProduct(paramMap);
		
		return selProduct;
	}
	
}
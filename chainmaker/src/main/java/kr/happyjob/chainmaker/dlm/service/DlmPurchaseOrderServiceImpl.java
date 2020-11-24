package kr.happyjob.chainmaker.dlm.service;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.happyjob.chainmaker.dlm.dao.DlmPurchaseOrderDao;
import kr.happyjob.chainmaker.dlm.model.DlmPurchaseOrderDTO;
import kr.happyjob.chainmaker.dlm.model.DlmPurchaseOrderVO;
import kr.happyjob.chainmaker.dlm.model.PurchaseOrderPgAndScKeyWordDTO;

@Service
public class DlmPurchaseOrderServiceImpl implements DlmPurchaseOrderService {

  @Autowired
  DlmPurchaseOrderDao dlmPurchaseOrderDao;
  
  @Override
  // 담당자 별 발주 리스트 목록 조회
  public List<DlmPurchaseOrderDTO> purchaseOrderListByMng(PurchaseOrderPgAndScKeyWordDTO purchaseOrderPgAndKeyWordDTO) throws Exception {
    // VO에서 DTO변환 과정
    List<DlmPurchaseOrderVO> purchaseOrderList = dlmPurchaseOrderDao.purchaseOrderListByMng(purchaseOrderPgAndKeyWordDTO);
    Iterator<DlmPurchaseOrderVO> iter = purchaseOrderList.iterator();
    
    List<DlmPurchaseOrderDTO> resultDTOList = new LinkedList<DlmPurchaseOrderDTO>();
    
    while (iter.hasNext()) {
      DlmPurchaseOrderVO dlmPurchaseOrderVO = iter.next();
      DlmPurchaseOrderDTO resultDTO = new DlmPurchaseOrderDTO(dlmPurchaseOrderVO);
      resultDTOList.add(resultDTO);
    }
    return resultDTOList;
  }

  @Override
  // 조회 목록 수 
  public int totalCnt(PurchaseOrderPgAndScKeyWordDTO purchaseOrderPgAndKeyWordDTO) throws Exception {
    return dlmPurchaseOrderDao.totalCnt(purchaseOrderPgAndKeyWordDTO);
  }
  
}

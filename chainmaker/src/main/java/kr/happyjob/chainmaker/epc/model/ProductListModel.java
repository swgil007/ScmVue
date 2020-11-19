package kr.happyjob.chainmaker.epc.model;

import java.util.Date;

public class ProductListModel {
		// 장비번호
		private String pro_num;

		// 장비구분
		private String pro_cod;

		// 모델번호
		private String pro_cod_num;

		// 모델명
		private String pro_cod_nam;

		// 제조사
		private String pro_manu_nm;
		
		// 판매가격
		private int pro_prc;
		
		// 상세설명
		private String pro_det;
		
		// 로그인 id
		private String login_id;
		
		// 납품일자
		private Date startDate;
		
		// 주문수량
		private int od_qty;
		
		
		public int getOd_qty() {
			return od_qty;
		}

		public void setOd_qty(int od_qty) {
			this.od_qty = od_qty;
		}

		public Date getOd_date() {
			return startDate;
		}

		public void setOd_date(Date startDate) {
			this.startDate = startDate;
		}

		public String getLogin_id() {
			return login_id;
		}

		public void setLogin_id(String login_id) {
			this.login_id = login_id;
		}
		
		public String getPro_det() {
			return pro_det;
		}

		public void setPro_det(String pro_det) {
			this.pro_det = pro_det;
		}

		public ProductListModel() {
			super();
			// TODO Auto-generated constructor stub
		}

		public ProductListModel(String pro_num, String pro_cod, String pro_cod_num, String pro_cod_nam, String pro_manu_nm,
				int pro_prc) {
			super();
			this.pro_num = pro_num;
			this.pro_cod = pro_cod;
			this.pro_cod_num = pro_cod_num;
			this.pro_cod_nam = pro_cod_nam;
			this.pro_manu_nm = pro_manu_nm;
			this.pro_prc = pro_prc;
		}

		public String getPro_num() {
			return pro_num;
		}

		public void setPro_num(String pro_num) {
			this.pro_num = pro_num;
		}

		public String getPro_cod() {
			return pro_cod;
		}

		public void setPro_cod(String pro_cod) {
			this.pro_cod = pro_cod;
		}

		public String getPro_cod_num() {
			return pro_cod_num;
		}

		public void setPro_cod_num(String pro_cod_num) {
			this.pro_cod_num = pro_cod_num;
		}

		public String getPro_cod_nam() {
			return pro_cod_nam;
		}

		public void setPro_cod_nam(String pro_cod_nam) {
			this.pro_cod_nam = pro_cod_nam;
		}

		public String getPro_manu_nm() {
			return pro_manu_nm;
		}

		public void setPro_manu_nm(String pro_manu_nm) {
			this.pro_manu_nm = pro_manu_nm;
		}

		public int getPro_prc() {
			return pro_prc;
		}

		public void setPro_prc(int pro_prc) {
			this.pro_prc = pro_prc;
		}
}

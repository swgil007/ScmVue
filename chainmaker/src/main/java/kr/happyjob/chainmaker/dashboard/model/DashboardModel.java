package kr.happyjob.chainmaker.dashboard.model;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
@Getter
@Setter
@ToString

public class DashboardModel {

	private int nt_no;
	private int nt_no2;
	private String loginID;
	private String nt_title;
	private String nt_note;
	private Date write_date;
	
	
	
	
}

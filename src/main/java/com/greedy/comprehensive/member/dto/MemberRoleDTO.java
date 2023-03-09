package com.greedy.comprehensive.member.dto;

import lombok.Data;

/* TBL_MEMBER_ROLE */
@Data
public class MemberRoleDTO {
	
	private int memberNo;
	private int authorityCode;
	
	/* TBL_AUTHORITY - 권한 코드별로 가지는 권한을 나타냄 */
	private AuthorityDTO authority;
}

package com.greedy.comprehensive.member.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greedy.comprehensive.common.exception.member.MemberModifyException;
import com.greedy.comprehensive.common.exception.member.MemberRegistException;
import com.greedy.comprehensive.common.exception.member.MemberRemoveException;
import com.greedy.comprehensive.member.dao.MemberMapper;
import com.greedy.comprehensive.member.dto.MemberDTO;
import com.greedy.comprehensive.member.dto.MemberRoleDTO;

@Service
@Transactional
public class MemberService {

    private final MemberMapper mapper;

    public MemberService(MemberMapper mapper) {
        this.mapper = mapper;
    }

    public boolean selectMemberById(String userId) {

        String result = mapper.selectMemberById(userId);

        return result != null ? true : false;
    }

    public void registMember(MemberDTO member) throws MemberRegistException{

        int result1 = mapper.insertMember(member);
        int result2 = mapper.insertMemberRole();

        if(!(result1 > 0 && result2 > 0)){
            throw new MemberRegistException("회원 가입에 실패하였습니다.");
        }
    }

    public void modifyMember(MemberDTO member) throws MemberModifyException {
        int result = mapper.updateMember(member);

        if(!(result > 0)) {
            throw new MemberModifyException("회원 정보 수정에 실패하셨습니다.");
        }
    }

    public void removeMember(MemberDTO member) throws MemberRemoveException {
        int result = mapper.deleteMember(member);

        if(!(result > 0)) {
            throw new MemberRemoveException("회원 탈퇴에 실패하셨습니다.");
        }
    }
}

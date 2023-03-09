package com.greedy.comprehensive.member.controller;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.greedy.comprehensive.common.exception.member.MemberModifyException;
import com.greedy.comprehensive.common.exception.member.MemberRegistException;
import com.greedy.comprehensive.common.exception.member.MemberRemoveException;
import com.greedy.comprehensive.member.dto.MemberDTO;
import com.greedy.comprehensive.member.service.AuthenticationService;
import com.greedy.comprehensive.member.service.MemberService;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/member")
public class MemberController {

	private final PasswordEncoder passwordEncoder;
    private final MessageSourceAccessor messageSourceAccessor;
    private final MemberService memberService;
    private final AuthenticationService authenticationService;

    public MemberController(MessageSourceAccessor messageSourceAccessor, MemberService memberService, PasswordEncoder passwordEncoder, AuthenticationService authenticationService) {
        this.messageSourceAccessor = messageSourceAccessor;
        this.memberService = memberService;
        this.passwordEncoder = passwordEncoder;
        this.authenticationService = authenticationService;
    }

    /* 로그인 페이지 이동 */
    @GetMapping("/login")
    public String goLogin() {

        return "member/login";
    }

    /* 로그인 실패 시 */
    @PostMapping("/loginfail")
    public String loginFailed(RedirectAttributes rttr) {
    	
    	rttr.addFlashAttribute("message", messageSourceAccessor.getMessage("error.login"));
    	
    	return "redirect:/member/login";
    }
    
    /* 회원 가입 페이지 이동 */
    @GetMapping("/regist")
    public String goRegister() {
    	
    	return "member/regist";
    }
    
    /* 아이디 중복 체크 - 비동기 통신 
     * 
     * HttpEntity 
     * : HTTP 요청(Request) 또는 응답(Response)에 해당하는 HttpHeader와 HttpBody를 포함하는 클래스
     *   이를 상속받아 구현한 클래스가 RequestEntity, ResponseEntity 클래스
     * ResponseEntity
     * : 사용자의 HttpRequest에 대한 응답 데이터를 포함하는 클래스
     *   (HttpStatus, HttpHeaders, HttpBody를 포함)
     *   
     * 규약에 맞는 HTTP Response를 반환하는데 ResponseEntity의 사용 목적이 있다.
     * */
    @PostMapping("/idDupCheck")
    public ResponseEntity<String> checkDuplication(@RequestBody MemberDTO member) {
    	
    	String result = "사용 가능한 아이디입니다.";
    	log.info("[MemberController] Request Check ID : {}", member.getMemberId());
    	
    	if(memberService.selectMemberById(member.getMemberId())) {
    		log.info("[MemberController] Already Exist");
    		result = "중복 된 아이디가 존재합니다.";
    	}    	
    	
    	return ResponseEntity.ok(result);
    }
    
    /* 회원 가입 */
    @PostMapping("/regist")
    public String registMember(@ModelAttribute MemberDTO member,
    		@RequestParam String zipCode, @RequestParam String address1, @RequestParam String address2,
    		RedirectAttributes rttr) throws MemberRegistException {
    	
    	String address = zipCode + "$" + address1 + "$" + address2;
    	member.setAddress(address);
    	member.setMemberPwd(passwordEncoder.encode(member.getMemberPwd()));
    	
    	log.info("[MemberController] registMember request Member : " + member);
    	
    	memberService.registMember(member);
    	
    	rttr.addFlashAttribute("message", messageSourceAccessor.getMessage("member.regist"));
    	
    	return "redirect:/";
    }
    
    /* 회원 정보 화면 이동 */
    @GetMapping("/update")
    public String goModifyMember(@AuthenticationPrincipal MemberDTO loginMember, Model model) {
    	
    	String[] address = loginMember.getAddress().split("\\$");
    	
    	model.addAttribute("address", address);
    	
    	return "member/update";
    }
    
    /* 회원 정보 수정 */
    @PostMapping("/update")
    public String modifyMember(@ModelAttribute MemberDTO updateMember,
    		@RequestParam String zipCode, @RequestParam String address1, @RequestParam String address2,
    		@AuthenticationPrincipal MemberDTO loginMember,
    		RedirectAttributes rttr) throws MemberModifyException {
    	
    	String address = zipCode + "$" + address1 + "$" + address2;
    	updateMember.setAddress(address);
    	/* 로그인 멤버 정보로부터 가져온 pk를 update용 member dto에 전달 */
    	updateMember.setMemberNo(loginMember.getMemberNo());
    	
    	log.info("[MemberController] modifyMember request Member : {}", updateMember);
    	
    	memberService.modifyMember(updateMember);
    	
    	/* 세션에 저장 되어 있는 로그인 회원의 정보를 변경한다. */
    	SecurityContextHolder.getContext().setAuthentication(createNewAuthentication(loginMember.getMemberId()));
    	
    	rttr.addFlashAttribute("message", messageSourceAccessor.getMessage("member.modify"));
    	
    	return "redirect:/";
    }
    
    /* 회원 정보 수정 시 세션에 저장 된 정보 업데이트 */
    protected Authentication createNewAuthentication(String memberId) {
    	
    	UserDetails newPrincipal = authenticationService.loadUserByUsername(memberId);
    	UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(newPrincipal, newPrincipal.getPassword(), newPrincipal.getAuthorities());

        return newAuth;
        
    }
    
    /* 회원 탈퇴 */
    @GetMapping("/delete")
    public String deleteMember(@AuthenticationPrincipal MemberDTO member, RedirectAttributes rttr) throws MemberRemoveException {
    	
        log.info("[MemberController] member : " + member);
        
        memberService.removeMember(member);

        SecurityContextHolder.clearContext();

        rttr.addFlashAttribute("message", messageSourceAccessor.getMessage("member.delete"));

        return "redirect:/";
    }
    
}

-- DB에 추가 시 계정 추가
-- CREATE USER C##SPRING IDENTIFIED BY SPRING;
-- GRANT CONNECT, RESOURCE, CREATE VIEW TO C##SPRING;
-- ALTER USER C##SPRING DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

-- 기존 테이블 삭제
DROP TABLE TBL_ATTACHMENT;
DROP TABLE TBL_REPLY;
DROP TABLE TBL_BOARD;
DROP TABLE TBL_MEMBER_ROLE;
DROP TABLE TBL_MEMBER;
DROP TABLE TBL_AUTHORITY;
DROP TABLE TBL_CATEGORY;

--기존 시퀀스 삭제
DROP SEQUENCE SEQ_MEMBER_NO;
DROP SEQUENCE SEQ_AUTHORITY_CODE;
DROP SEQUENCE SEQ_BOARD_NO;
DROP SEQUENCE SEQ_REPLY_NO;
DROP SEQUENCE SEQ_ATTACHMENT_NO;

-- 시퀀스 생성
CREATE SEQUENCE SEQ_MEMBER_NO;
CREATE SEQUENCE SEQ_AUTHORITY_CODE;
CREATE SEQUENCE SEQ_BOARD_NO;
CREATE SEQUENCE SEQ_REPLY_NO;
CREATE SEQUENCE SEQ_ATTACHMENT_NO;

-- TABLE 생성
-- MEMBER 테이블 생성
CREATE TABLE TBL_MEMBER(
  MEMBER_NO NUMBER PRIMARY KEY,
  MEMBER_ID VARCHAR2(20) UNIQUE NOT NULL,
  MEMBER_PWD VARCHAR2(255) NOT NULL,
  NICKNAME VARCHAR2(255) NOT NULL,
  PHONE VARCHAR2(20),
  EMAIL VARCHAR2(50),
  ADDRESS VARCHAR2(255),
  ENROLL_DATE DATE DEFAULT SYSDATE NOT NULL,
  MEMBER_STATUS VARCHAR2(2) DEFAULT 'Y' NOT NULL
);

-- TBL_AUTHORITY 추가
CREATE TABLE TBL_AUTHORITY(	
  AUTHORITY_CODE NUMBER PRIMARY KEY, 
  AUTHORITY_NAME VARCHAR2(255) NOT NULL, 
  AUTHORITY_DESC VARCHAR2(4000) NOT NULL
);

-- TBL_MEMBER_ROLE 추가
CREATE TABLE TBL_MEMBER_ROLE(	
  MEMBER_NO NUMBER, 
  AUTHORITY_CODE NUMBER,
  PRIMARY KEY (MEMBER_NO, AUTHORITY_CODE),
  FOREIGN KEY (MEMBER_NO) REFERENCES TBL_MEMBER(MEMBER_NO),
  FOREIGN KEY (AUTHORITY_CODE) REFERENCES TBL_AUTHORITY(AUTHORITY_CODE)
);

-- 권한 추가
INSERT INTO TBL_AUTHORITY (AUTHORITY_CODE,AUTHORITY_NAME,AUTHORITY_DESC) values (SEQ_AUTHORITY_CODE.NEXTVAL ,'ROLE_MEMBER','일반회원');
INSERT INTO TBL_AUTHORITY (AUTHORITY_CODE,AUTHORITY_NAME,AUTHORITY_DESC) values (SEQ_AUTHORITY_CODE.NEXTVAL,'ROLE_ADMIN','관리자');

-- 계정 추가
INSERT INTO TBL_MEMBER (MEMBER_NO, MEMBER_ID, MEMBER_PWD, NICKNAME, PHONE, EMAIL, ADDRESS) VALUES (SEQ_MEMBER_NO.NEXTVAL, 'admin', '$2a$12$OoovdT4FMf7vszMob7SeiODn7HNJHNZDr6BJhSZ5XaLqs/IFyYckS', '관리자', '01012345678', 'admin@greedy.com', '$$');
INSERT INTO TBL_MEMBER (MEMBER_NO, MEMBER_ID, MEMBER_PWD, NICKNAME, PHONE, EMAIL, ADDRESS) VALUES (SEQ_MEMBER_NO.NEXTVAL, 'test01', '$2a$12$OoovdT4FMf7vszMob7SeiODn7HNJHNZDr6BJhSZ5XaLqs/IFyYckS', '홍길동', '01012345678', 'test01@greedy.com', '$$');

-- 계정별 권한 추가
INSERT INTO TBL_MEMBER_ROLE (MEMBER_NO,AUTHORITY_CODE) values (1,1);
INSERT INTO TBL_MEMBER_ROLE (MEMBER_NO,AUTHORITY_CODE) values (1,2);
INSERT INTO TBL_MEMBER_ROLE (MEMBER_NO,AUTHORITY_CODE) values (2,1);

COMMIT;

-- 카테고리 테이블 생성
CREATE TABLE TBL_CATEGORY(
  CATEGORY_CODE NUMBER PRIMARY KEY,
  CATEGORY_NAME VARCHAR2(30) CHECK(CATEGORY_NAME IN('공통', '운동', '등산', '게임', '낚시', '요리', '기타'))  
);

-- 카테고리 테이블에 카테고리 추가
INSERT INTO TBL_CATEGORY (CATEGORY_CODE, CATEGORY_NAME) VALUES(10, '공통');
INSERT INTO TBL_CATEGORY (CATEGORY_CODE, CATEGORY_NAME) VALUES(20, '운동');
INSERT INTO TBL_CATEGORY (CATEGORY_CODE, CATEGORY_NAME) VALUES(30, '등산');
INSERT INTO TBL_CATEGORY (CATEGORY_CODE, CATEGORY_NAME) VALUES(40, '게임');
INSERT INTO TBL_CATEGORY (CATEGORY_CODE, CATEGORY_NAME) VALUES(50, '낚시');
INSERT INTO TBL_CATEGORY (CATEGORY_CODE, CATEGORY_NAME) VALUES(60, '요리');
INSERT INTO TBL_CATEGORY (CATEGORY_CODE, CATEGORY_NAME) VALUES(70, '기타');
COMMIT;

-- 게시판 테이블 생성
CREATE TABLE TBL_BOARD (
  BOARD_NO NUMBER PRIMARY KEY,
  BOARD_TYPE NUMBER NOT NULL CHECK(BOARD_TYPE IN (1, 2)),
  CATEGORY_CODE NUMBER,
  BOARD_TITLE VARCHAR2(100),
  BOARD_BODY VARCHAR2(4000) NOT NULL,
  BOARD_WRITER_MEMBER_NO NUMBER NOT NULL,
  BOARD_COUNT NUMBER DEFAULT 0 NOT NULL,
  CREATED_DATE DATE DEFAULT SYSDATE,
  MODIFIED_DATE DATE DEFAULT SYSDATE,
  BOARD_STATUS VARCHAR2(1) DEFAULT 'Y',
  FOREIGN KEY (BOARD_WRITER_MEMBER_NO) REFERENCES TBL_MEMBER(MEMBER_NO),
  FOREIGN KEY (CATEGORY_CODE) REFERENCES TBL_CATEGORY(CATEGORY_CODE)
);

-- 게시물 샘플 추가
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '1 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '2 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '3 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '4 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '5 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '6 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '7 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '8 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '9 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '10 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '11 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '12 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '13 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '14 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '15 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '16 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '17 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '18 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '19 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '20 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '21 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '22 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '23 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '24 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '25 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '26 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '27 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '28 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '29 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '30 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '31 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '32 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '33 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '34 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '35 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '36 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '37 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '38 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '39 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '40 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '41 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '42 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '43 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '44 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '45 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '46 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '47 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '48 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '49 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '50 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '51 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '52 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '53 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '54 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '55 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '56 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '57 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '58 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '59 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '60 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '61 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '62 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '63 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '64 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '65 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '66 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '67 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '68 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '69 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '70 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '71 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '72 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '73 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '74 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '75 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '76 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '77 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '78 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '79 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '80 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '81 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '82 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '83 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '84 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '85 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '86 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '87 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '88 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '89 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '90 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '91 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '92 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '93 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '94 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '95 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '96 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '97 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '98 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '99 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '100 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '101 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '102 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '103 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '104 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '105 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '106 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '107 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '108 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '109 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '110 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '111 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '112 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '113 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '114 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '115 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '116 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '117 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '118 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '119 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '120 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '121 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '122 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);
INSERT INTO TBL_BOARD (BOARD_NO, BOARD_TYPE, CATEGORY_CODE, BOARD_TITLE, BOARD_BODY, BOARD_WRITER_MEMBER_NO)
VALUES (SEQ_BOARD_NO.NEXTVAL, 1, 10, '123 번째 게시물 입니다.', '내용은 없습니다. WE CAN DO IT!~', 1);

COMMIT;

-- REPLY 테이블 생성
CREATE TABLE TBL_REPLY (
  REPLY_NO NUMBER PRIMARY KEY,
  REF_BOARD_NO NUMBER,
  REPLY_BODY VARCHAR2(4000),
  REPLY_WRITER_MEMBER_NO NUMBER,
  REPLY_STATUS VARCHAR2(1) DEFAULT 'Y',
  CREATED_DATE DATE DEFAULT SYSDATE,
  FOREIGN KEY (REF_BOARD_NO) REFERENCES TBL_BOARD(BOARD_NO),
  FOREIGN KEY (REPLY_WRITER_MEMBER_NO) REFERENCES TBL_MEMBER(MEMBER_NO)
);

-- 첨부파일 테이블 생성
CREATE TABLE TBL_ATTACHMENT (
  ATTACHMENT_NO NUMBER PRIMARY KEY,
  REF_BOARD_NO NUMBER NOT NULL,
  ORIGINAL_NAME VARCHAR2(255) NOT NULL,
  SAVED_NAME VARCHAR2(255) NOT NULL,
  SAVE_PATH VARCHAR2(1000) NOT NULL,
  FILE_TYPE VARCHAR2(5) CHECK(FILE_TYPE IN ('TITLE', 'BODY')),
  THUMBNAIL_PATH VARCHAR2(255),
  ATTACHMENT_STATUS VARCHAR2(1) DEFAULT 'Y',
  FOREIGN KEY (REF_BOARD_NO) REFERENCES TBL_BOARD(BOARD_NO)  
);

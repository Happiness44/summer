-- 게시판 TABLE
-- 자유게시판
ALTER TABLE SU_BOARD
	DROP CONSTRAINT PK_SU_BOARD; -- 자유게시판 기본키

-- 자유게시판
DROP TABLE SU_BOARD;

-- 자유게시판
CREATE TABLE SU_BOARD (
	NUM       NUMBER(8)         NOT NULL, -- 글번호
	CATEGORY  VARCHAR2(5)       NOT NULL, -- 글구분
	TITLE     VARCHAR2(50 BYTE) NOT NULL, -- 제목
	ID        VARCHAR2(20 BYTE) NOT NULL, -- 작성자
	CONTENT   CLOB              NOT NULL, -- 글내용
	DATE_REG  DATE              NOT NULL, -- 작성일
	CLICK_CNT NUMBER(4)         NOT NULL, -- 조회수
	LIKE_CNT  NUMBER(4)         NOT NULL  -- 좋아요
);

-- 자유게시판
ALTER TABLE SU_BOARD
	ADD
		CONSTRAINT PK_SU_BOARD -- 자유게시판 기본키
		PRIMARY KEY (
			NUM -- 글번호
		);    


-- 댓글 TABLE

-- 댓글
ALTER TABLE SU_COMMENT
	DROP CONSTRAINT PK_SU_COMMENT; -- 댓글 기본키

-- 댓글
DROP TABLE SU_COMMENT;

-- 댓글
CREATE TABLE SU_COMMENT (
	NUM        NUMBER(8)          NOT NULL, -- 글번호
	R_NUM      NUMBER(8)          NOT NULL, -- 댓글번호
	R_CONTENT  VARCHAR2(100 BYTE) NOT NULL, -- 댓글내용
	ID         VARCHAR2(20 BYTE)  NOT NULL, -- 댓글작성자
	R_DATE_REG DATE               NOT NULL  -- 댓글작성일
);

-- 댓글
ALTER TABLE SU_COMMENT
	ADD
		CONSTRAINT PK_SU_COMMENT -- 댓글 기본키
		PRIMARY KEY (
			NUM,   -- 글번호
			R_NUM  -- 댓글번호
		);

-- 회원 TABLE
-- 회원
ALTER TABLE SU_USERS
	DROP CONSTRAINT PK_SU_USERS; -- 회원 기본키

-- 회원
DROP TABLE SU_USERS;

-- 회원
CREATE TABLE SU_USERS (
	ID       VARCHAR2(20 BYTE) NOT NULL, -- 아이디
	PWD      VARCHAR2(20 BYTE) NOT NULL, -- 비밀번호
	NAME     VARCHAR2(10 CHAR) NOT NULL, -- 이름
	NICKNAME VARCHAR2(10 CHAR) NOT NULL, -- 별명
	GENDER   VARCHAR2(5)       NOT NULL, -- 성별
	BIRTH    NUMBER(8)         NOT NULL, -- 생년월일
	EMAIL    VARCHAR2(50 BYTE) NOT NULL, -- 이메일
	PHONE    NUMBER(11)        NOT NULL, -- 연락처
	GRADE    NUMBER(1)         NOT NULL  -- 등급
);

-- 회원 기본키
CREATE UNIQUE INDEX UK_SU_USERS_NICKNAME
	ON SU_USERS ( -- 회원
		NICKNAME ASC -- 아이디
	);
	
-- 회원 기본키
CREATE UNIQUE INDEX UK_SU_USERS_PHONE
	ON SU_USERS ( -- 회원
		PHONE ASC -- 아이디
	);

-- 회원
ALTER TABLE SU_USERS
	ADD
		CONSTRAINT "PK_SU_USERS" -- 회원 기본키
		PRIMARY KEY (
			"ID" -- 아이디
		);



-- 금융상품즐겨찾기 TABLE

-- 금융상품즐겨찾기
ALTER TABLE "SU_FINFAVS"
	DROP CONSTRAINT "PK_SU_FINFAVS"; -- 금융상품즐겨찾기 기본키

DROP TABLE "SU_FINFAVS";

CREATE TABLE "SU_FINFAVS" (
	"FAVS_NO"     NUMBER(8)         NOT NULL, -- 즐겨찾기번호
	"ID"          VARCHAR2(20 BYTE) NOT NULL, -- 회원ID
	"DCLS_MONTH"  NUMBER(6)         NOT NULL, -- 공시제출월
	"FIN_CO_NO"   NUMBER(8)         NOT NULL, -- 금융회사코드
	"FIN_PRDT_CD" VARCHAR2(30 BYTE) NOT NULL  -- 금융상품코드
);

CREATE UNIQUE INDEX "PK_SU_FINFAVS"
	ON "SU_FINFAVS" ( -- 금융상품즐겨찾기
		"FAVS_NO" ASC -- 즐겨찾기번호
	);

ALTER TABLE "SU_FINFAVS"
	ADD
		CONSTRAINT "PK_SU_FINFAVS" -- 금융상품즐겨찾기 기본키
		PRIMARY KEY (
			"FAVS_NO" -- 즐겨찾기번호
		);

-- SEQUENCE
CREATE SEQUENCE FINFAVS_SEQ
INCREMENT BY 1
START WITH 1
NOMAXVALUE
MINVALUE 1
NOCYCLE
CACHE 10;

-- 코드테이블

ALTER TABLE "SU_CODES"
	DROP CONSTRAINT "PK_SU_CODES"; -- 코드테이블 기본키

DROP TABLE "SU_CODES";

CREATE TABLE "SU_CODES" (
	"CD_MST_ID"   VARCHAR2(30 BYTE)  NOT NULL, -- 마스터코드_ID
	"CD_DTL_ID"   VARCHAR2(5)        NOT NULL, -- 상세코드_ID
	"CD_MST_NM"   VARCHAR2(200 CHAR) NOT NULL, -- 마스터코드명
	"CD_DTL_NM"   VARCHAR2(200 CHAR) NOT NULL, -- 상세코드명
	"CD_SEQ"      NUMBER(4)          NOT NULL, -- 정렬순서
	"CD_P_MST_ID" VARCHAR2(30 BYTE)  NULL,     -- 상위마스터코드_ID
	"CD_USE_YN"   NUMBER(1)          NOT NULL DEFAULT 1 -- 사용여부
);

-- 코드테이블 기본키
CREATE UNIQUE INDEX "PK_SU_CODES"
	ON "SU_CODES" ( -- 코드테이블
		"CD_MST_ID" ASC, -- 마스터코드_ID
		"CD_DTL_ID" ASC  -- 상세코드_ID
	);

ALTER TABLE "SU_CODES"
	ADD
		CONSTRAINT "PK_SU_CODES" -- 코드테이블 기본키
		PRIMARY KEY (
			"CD_MST_ID", -- 마스터코드_ID
			"CD_DTL_ID"  -- 상세코드_ID
		);

-- 사용여부
COMMENT ON COLUMN "SU_CODES"."CD_USE_YN" IS '0 미사용 1 사용';

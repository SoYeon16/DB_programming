CREATE OR Replace PROCEDURE DeleteEnroll (
		sStudentId IN NUMBER, 
		sCourseId IN VARCHAR2, 
		nCourseIdNo IN NUMBER,
		result2 OUT VARCHAR2)
IS
BEGIN
	result2 := '';

	DBMS_OUTPUT.put_line('#');
	DBMS_OUTPUT.put_line(sStudentId || '님이 과목번호 ' || sCourseId || ', 분반 ' || TO_CHAR(nCourseIdNo) || '의 수강 취소를 요청하였습니다.');

	DELETE
	FROM enroll
	WHERE s_id = sStudentId and c_id = sCourseId and c_id_no = nCourseIdNo;

	COMMIT;
	result2 := '수강취소가 완료되었습니다.';

EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		result2 := SQLCODE;
END;
/
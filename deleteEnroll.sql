CREATE OR Replace PROCEDURE DeleteEnroll (
		sStudentId IN NUMBER, 
		sCourseId IN VARCHAR2, 
		nCourseIdNo IN NUMBER,
		result2 OUT VARCHAR2)
IS
BEGIN
	result2 := '';

	DBMS_OUTPUT.put_line('#');
	DBMS_OUTPUT.put_line(sStudentId || '���� �����ȣ ' || sCourseId || ', �й� ' || TO_CHAR(nCourseIdNo) || '�� ���� ��Ҹ� ��û�Ͽ����ϴ�.');

	DELETE
	FROM enroll
	WHERE s_id = sStudentId and c_id = sCourseId and c_id_no = nCourseIdNo;

	COMMIT;
	result2 := '������Ұ� �Ϸ�Ǿ����ϴ�.';

EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		result2 := SQLCODE;
END;
/
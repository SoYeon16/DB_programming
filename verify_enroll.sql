
CREATE OR REPLACE PROCEDURE SelectTimeTable(
  		sStudentId IN VARCHAR2,
		nYear      IN NUMBER,
		nSemester  IN NUMBER)					
IS
	sId COURSE.C_ID%TYPE;
	sName COURSE.C_NAME%TYPE;
	nIdNo COURSE.C_ID_NO%TYPE;
	nUnit COURSE.C_UNIT%TYPE;

	nSTime_h course.c_start_hh%TYPE;
	nSTime_m course.c_start_mm%TYPE;
	nETime_h course.c_end_hh%TYPE;
	nETime_m course.c_end_mm%TYPE;

	sWhere course.c_where%TYPE;
	nTotUnit NUMBER := 0;
 

CURSOR cur (sStudentId VARCHAR2, nYear NUMBER, nSemester NUMBER) IS
	SELECT e.c_id, c.c_name, e.c_id_no, c.c_unit, c.c_start_hh, c.c_start_mm, c.c_end_hh, c.c_end_mm, c.c_where
	FROM enroll e, course c
	WHERE e.s_id = sStudentId and e.e_year = nYear and e.e_semester=nSemester and
		  e.e_year = nYear  and e.e_semester = nSemester and
		  e.c_id = c.c_id and e.c_id_no=c.c_id_no and
		  c.c_id=e.c_id and c.c_id_no = e.c_id_no
	ORDER BY 5;

BEGIN
	OPEN cur(sStudentId, nYear, nSemester); 

	DBMS_OUTPUT.put_line('#');
	DBMS_OUTPUT.put_line(TO_CHAR(nYear) || '년도 ' || TO_CHAR(nSemester) || '학기의 ' || sStudentId || '님의 수강신청 시간표입니다.');                        
  
LOOP
	FETCH cur INTO sId, sName, nIdNo, nUnit, nSTime_h, nSTime_m, nETime_h, nETime_m, sWhere;
	EXIT  WHEN cur%NOTFOUND;

	DBMS_OUTPUT.put_line('교시:' || TO_CHAR(nSTime_h) || TO_CHAR(nSTime_m) || TO_CHAR(nETime_h) || TO_CHAR(nETime_m) || ', 과목번호:' || sID || 
			  ', 과목명:'|| sName || ', 분반:' || TO_CHAR(nIdNo) ||
			  ', 학점:' || TO_CHAR(nUnit) ||	 ', 장소:' || sWhere);

	nTotUnit := nTotUnit + nUnit;
END LOOP;

	DBMS_OUTPUT.put_line('총 ' || TO_CHAR(cur%ROWCOUNT) || ' 과목과 총 ' || TO_CHAR(nTotUnit) || '학점을 신청하였습니다.');

	CLOSE cur;
END;
/
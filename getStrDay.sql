CREATE OR REPLACE FUNCTION getStrDay (
	course_day VARCHAR
)
RETURN VARCHAR
IS
	modified_course_day VARCHAR(10);	
BEGIN
	SELECT REPLACE(course_day, '0', '��')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '1', '��')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '2', 'ȭ')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '3', '��')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '4', '��')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '5', '��')
	INTO modified_course_day
	FROM DUAL;

	SELECT REPLACE(modified_course_day, '6', '��')
	INTO modified_course_day
	FROM DUAL;
	COMMIT;
	
RETURN modified_course_day;
END;
/
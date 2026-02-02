SELECT * FROM employees;


CREATE TABLE salary_audit (
    audit_id     NUMBER GENERATED ALWAYS AS IDENTITY,
    emp_id       NUMBER,
    old_salary   NUMBER,
    new_salary   NUMBER,
    change_date  DATE
);


DESC salary_audit;


CREATE OR REPLACE PROCEDURE apply_salary_hike (
    p_emp_id NUMBER,
    p_percent NUMBER
)
AS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * p_percent / 100)
    WHERE emp_id = p_emp_id;

    COMMIT;
END;
/


BEGIN
    apply_salary_hike(1, 10);
END;
/


SELECT emp_id, salary FROM employees WHERE emp_id = 1;


CREATE OR REPLACE TRIGGER salary_update_audit
AFTER UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_audit (
        emp_id,
        old_salary,
        new_salary,
        change_date
    )
    VALUES (
        :OLD.emp_id,
        :OLD.salary,
        :NEW.salary,
        SYSDATE
    );
END;
/


BEGIN
    apply_salary_hike(2, 15);
END;
/


SELECT * FROM salary_audit;



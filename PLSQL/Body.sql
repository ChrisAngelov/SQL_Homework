Create or replace Package BODY electronics_merchant as
--plsql 1 
    --get the underling count for set sal 
    Function get_underling_count(v_empID Employees.employee_id%TYPE) return number as
        v_count number := 0;
        cursor searchunderlings(c_empID Employees.employee_id%TYPE) is
            Select employee_id from employees where manager_id = c_empID;
    Begin
    
        for i in searchunderlings(v_empID) LOOP
            v_count:= v_count + 1;
            v_count := v_count + get_underling_count(i.employee_id);
        END LOOP;
        return v_count;
    END;
    --Set salary for emps 
    Procedure set_salary as
        v_salary number := 1750;
        cursor get_emp is
            Select c.salary,e.employee_id,e.hire_date,e.job_title
            from Employees e join Compensations c 
            on e.employee_id = c.employee_id
            for update;
    Begin
            For i in get_emp Loop
            v_salary := 1750;
            v_salary := v_salary + Round(((i.Hire_date-sysdate)*0.25));
            v_salary := v_salary + round((get_underling_count(i.employee_id)*0.5));
            if i.job_title = 'Programmer' then
                v_salary := v_salary + 250;
            end if;
            update Compensations set salary = v_salary where current of get_emp;
        End Loop;
        commit;
    exception
        when others then
            rollback;
    End;
    --Add new emp 
    PROCEDURE add_employee(new_employee rt_new_employee) as
        Cursor get_jtitle is
        Select job_title 
        from Employees
        group by job_title;
        
        v_title employees.job_title%TYPE;
        v_id employees.employee_id%TYPE;
    
    BEGIN
        Select MAX(employee_id) into v_id from employees;

        Select DISTINCT job_title into v_title from employees
            where job_title Like new_employee.varjob;
        
        if v_title is not null then
            Insert into employees(employee_id,first_name,last_name,email,phone,hire_date,manager_id,job_title)
            Values(v_id + 1,new_employee.varfname,new_employee.varlname,new_employee.varemail,new_employee.varphone,sysdate,4,new_employee.varjob);
            
            Insert into Compensations (employee_id,Salary) values (v_id+1, 1750);  
        END IF;

        Exception
            when NO_DATA_FOUND then
                dbms_output.put_line( 'Job does not exist or is written wrong' ) ;
                v_title := null;  
    End; 

    --set manager defines the manager of an emp
    Procedure set_manager(emp_id Employees.employee_id%TYPE, man_id Employees.manager_id%TYPE) as
        v_name employees.first_name%TYPE;
        v_man_name employees.first_name%TYPE;
    BEGIN
        select first_name into v_name from employees
            where emp_id like employee_id;
            
        if emp_id like man_id then
            v_name:= null;
        elsif v_name is not null then
            update employees
            set manager_id = man_id
            where employee_id like emp_id;
        end IF;
        commit;
        Exception
            when NO_DATA_FOUND then
                v_name := null; 
    END;
    
--plsql 2 
    --add a new order 
    PROCEDURE add_order(newOrder rt_new_order) as
        v_order_id number;
        v_order_item_id number;
    Begin
        Select MAX(Order_id) + 1 into v_order_id from Orders;
        
        INSERT INTO orders (order_id, customer_id, status, salesman_id, order_date)
        VALUES(v_order_id, newOrder.customer_id, 'Pending', newOrder.salesman_id, SYSDATE);
        
        FOR i in 1..newOrder.order_items.count Loop
        Select MAX(Item_id) + 1 into v_order_item_id from order_items;
        
        Insert into Order_items(order_id,item_id,product_id,quantity,unit_price)
        Values (v_order_id,v_order_item_id,newOrder.order_items(i).product_id,newOrder.order_items(i).quantity,newOrder.order_items(i).unit_price);
    end loop;
    END; 
    --validate the order
    FUNCTION validate_order(p_new_order rt_new_order) RETURN BOOLEAN
    AS
        TYPE at_ids IS VARRAY(2) OF NUMBER;
        v_ids at_ids;

        v_result NUMBER;
        v_result1 inventories%ROWTYPE;
    BEGIN

        v_ids := at_ids(p_new_order.salesman_id, p_new_order.customer_id);
        SELECT employee_id INTO v_result FROM employees WHERE employee_id = v_ids(1);
        SELECT customer_id INTO v_result FROM customers WHERE customer_id = v_ids(2);

        FOR  i IN 1 .. p_new_order.order_items.COUNT LOOP
            SELECT * INTO v_result1 FROM inventories
            WHERE product_id = p_new_order.order_items(1).product_id AND quantity - p_new_order.order_items(1).quantity >= 0; 
        END LOOP;
            RETURN TRUE;
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    END;
    
    --update order
    Procedure Update_Order(Ord_id NUMBER,sale_id NUMBER,stats Varchar) as
        v_id Number;
        s_id number;
        not_null_statement EXCEPTION;
        PRAGMA Exception_init(not_null_statement, -20002);    
    Begin
        
        SELECT salesman_id into s_id from Orders where salesman_id = sale_id;
        Select order_id into v_id from Orders where order_id = Ord_id;
        
        IF stats is NULL then
            RAISE_application_error(-20002,'Error status cant be null');
        END IF;
        
        Update Orders
            Set Status = stats, Salesman_id = sale_id
                    where Order_id = Ord_id;
        
        Exception when NO_DATA_FOUND then
            RAISE NO_DATA_FOUND;    
    END;
    
    --update order items 
    Procedure Update_Order_item(up_order rt_new_order_update) as
    v_id order_items.order_id%TYPE;
    
    BEGIN
        SELECT order_id into v_id from order_items where order_id = up_order.order_id;
        
        IF up_order.do_delete = true and up_order.do_insert = false then
            Delete from Order_items
            where Order_id = up_order.order_id;
        
        elsif up_order.do_insert = true then
            insert into Order_items(order_id, item_id, product_id, quantity, unit_price)
                values(up_order.order_id, up_order.item_id, up_order.p_id, up_order.new_q, up_order.new_up);
        
        end if;
            Update order_items
            set order_id = up_order.order_id,
                item_id = up_order.item_id,
                product_id = up_order.p_id,
                quantity = up_order.new_q,
                Unit_price = up_order.new_up
            where order_id =  v_id;
        
        Exception when NO_DATA_FOUND then
            RAISE NO_DATA_FOUND;
    END;
    
    --calc bonus
    Function calc_bonus(e_id employees.employee_id%type) return number as
        v_order_id orders.order_id%TYPE;
        v_unitp order_items.unit_price%TYPE;
        v_quan order_items.quantity%TYPE;
        v_bonus Compensations.bonus%TYPE;
    
    BEGIN
    
        Select order_id into v_order_id from orders where salesman_id = e_id;
        select unit_price into v_unitp from order_items where order_id = v_order_id;
        select quantity into v_quan from order_items where order_id = v_order_id;
        v_bonus := (v_unitp*v_quan)*0.75;
        
        return v_bonus;
    

    Exception when NO_DATA_FOUND then
        RAISE NO_DATA_FOUND;
    END;
    
    --set bonus
    procedure set_bonus(e_id employees.employee_id%type) as
        v_bonus Compensations.bonus%TYPE;
    BEGIN
    
        v_bonus := calc_bonus(e_id);
    
        Update Compensations
        Set Bonus = v_bonus
        where e_id = employee_id;
    
    END;

--plsql 3

    function get_company_value return rt_country_value as 
        Cursor get_values is Select * from STOCK_VALUE_BY_COUNTRY;
        v_cv rt_company_value;
        v_cs rt_country_stock;
        arr arr_country_values;
    Begin

        For i in get_values Loop
            v_cs.no_of_warhouses := i.Warehouses;
            v_cs.total_stock_value := i.Total_stock_value;
            v_cs.value_percentage := TO_CHAR(i.Percents) + '%';
    
            arr(i.Country) := v_cs;
    
            v_cv.country_values := arr(i.Country);
            SELECT SUM(total_stock_value) into v_cv.total_value From total_stock_value;
        End Loop;
        return v_cv;
    END;
    
    function get_errors(it inventories%rowtype) return varchar2 is
    maybe_error varchar2(100) := '';
    Begin
        if it.warehouse_id = 0 then
            maybe_error :=  maybe_error+'Warehouse not found';
        elsif it.product_id  = 0 then
            maybe_error :=  maybe_error+'Prodcut not found';
        elsif it.quantity <= 0 then 
            maybe_error :=  maybe_error+'Quantity not maching';
        END IF;

        return maybe_error;
    END;
    
    Procedure process_inventory_counts(rt Nested_table) is
        trigger_exception exception;
        error_details varchar2(100);
    Begin
    for table_index in rt.first..rt.last loop
        error_details := get_errors(rt(table_index));
        if error_details != '' then raise trigger_exception; end if;
        Update Inventories
        set quantity = rt(table_index).quantity
        where warehouse_id = rt(table_index).warehouse_id and product_id = rt(table_index).product_id;
    end loop;

    Exception
    when trigger_exception then
        dbms_output.put_line(error_details);
    END;
End electronics_merchant; 







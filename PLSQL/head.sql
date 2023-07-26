Set serveroutput on;
--aitbuAs7
Create or replace Package electronics_merchant is
    
    -- sql rep 2 
    TYPE rt_order_item IS RECORD(
        product_id  NUMBER( 12, 0 ),
        quantity    NUMBER( 8, 2 ),
        unit_price  NUMBER( 8, 2 )
    );

    TYPE tt_order_item IS TABLE OF rt_order_item; 
    
     
    Type rt_new_order is Record (
        customer_id Orders.customer_id%TYPE,
        salesman_id Orders.salesman_id%TYPE,
        order_items tt_order_item
    );
    
    Type rt_new_order_update is Record (
        order_id Order_items.order_id%TYPE,
        item_id Order_items.Item_id%TYPE,
        do_delete boolean,
        do_insert boolean,
        --somthing weird was going on would not recognize %type
        p_id NUMBER( 12, 0 ),
        new_q NUMBER( 8, 2 ),
        new_up NUMBER( 8, 2 )
    );
    
    -- sql rep 1 
    Type rt_new_employee is Record (
        varfname employees.first_name%TYPE,
        varlname employees.last_name%TYPE,
        varemail employees.email%TYPE,
        varphone employees.phone%TYPE,
        varjob employees.job_title%TYPE
    );
    -- sql rep 3
    
     TYPE rt_country_stock IS RECORD(
        no_of_warehouses number,
        total_stock_value number,
        value_percentage varchar2(10)
    );
    TYPE arr_country_values IS TABLE OF rt_country_stock INDEX BY varchar2(2);

    TYPE rt_company_value IS RECORD(
    --69/39     PLS-00201: identifier 'RT_COUNTRY_VALUES' must be declared

        country_values arr_country_values,
        total_value number
    );
    type Nested_table is table of inventories%rowtype;



    -- sql rep 1 
    Function get_underling_count(v_empID Employees.employee_id%TYPE) return number;
    Procedure set_salary; 
    PROCEDURE add_employee(new_employee rt_new_employee);
    Procedure set_manager(emp_id Employees.employee_id%TYPE, man_id Employees.manager_id%TYPE); 
    -- sql rep 2
    PROCEDURE add_order(newOrder rt_new_order);
    FUNCTION validate_order(p_new_order rt_new_order)return boolean;
    Procedure Update_Order(Ord_id NUMBER,sale_id NUMBER,stats Varchar);
    Procedure Update_Order_item(up_order rt_new_order_update);
    Function calc_bonus(e_id employees.employee_id%type) return number;
    procedure set_bonus(e_id employees.employee_id%type);
    --sql rep 3

    function get_company_value return rt_company_value;
    function get_errors(it inventories%rowtype) return varchar2;
     Procedure process_inventory_counts(rt Nested_table); 
    


    
end electronics_merchant; 
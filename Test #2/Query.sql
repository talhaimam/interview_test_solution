--MySQL using find_in_set function
select  employee_id
from    (select * from employees where employee_id != 1
         order by manager_id, employee_id) rank_sorted,
        (select @pv := '1') initialisation
where   find_in_set(manager_id, @pv)
and     length(@pv := concat(@pv, ',', employee_id))

--MySQL using recursion
with recursive resultset AS 
( select employee_id, employee_name, manager_id from employees where manager_id = 1 and employee_id != 1
union all
select e.employee_id, e.employee_name, e.manager_id FROM employees e inner join resultset on e.manager_id = resultset.employee_id)
select * from resultset

--With Traditional joins since we know the number of levels
select e1.employee_id
from        employees e1
left join   employees e2 on e2.employee_id = e1.manager_id 
left join   employees e3 on e3.employee_id = e2.manager_id
where       e1.employee_id != 1 and 1 in (e1.manager_id, 
                   e2.manager_id, e3.manager_id) 
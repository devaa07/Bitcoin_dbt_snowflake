{% test assert_valid_address_pattern(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} not like '1%'
  and {{ column_name }} not like '3%'
  and {{ column_name }} not like 'bc1%'
{% endtest %}
![](http://www.solidq.com/wp-content/uploads/2015/06/Logo-SolidQ-Web.gif)

# ABA Framework Last Test Execution


{% if error_test > 0 %}## {{message}}
Se han encontrado {{error_test}} errores.
{% endif -%}

{% if error_test == 0 %}## {{message}}
La ejecución finalizó sin errores.
{% endif -%}

| test_name | source_schema | source_table_name | status | execution_date | executed | message |
| --------- | ------------- | ----------------- | ------ | -------------- | -------- | ------- |
{% for exec in last_execution_tests -%}| {{exec.test_name}} | {{exec.source_schema}} | {{exec.source_table_name}} | {{exec.current_error_status_desc}} | {{exec.execution_date}} | {{exec.executed}} | {% if exec.current_error_status_desc == 'Error' %}[See message](#head_test_{{exec.id}}) | {% else %} | |{% endif %}
{% endfor -%}

#### Test Results
{% for exec in last_execution_tests -%}
{% if exec.current_error_status_desc == 'Error' %}
##### Test {{exec.test_name}} <a name='head_test_{{exec.id}}'>
{% for test_error_message in exec.etl_test_result_messages -%}
```json
{{test_error_message.message_information}}
```
{% endfor -%}
{% endif %}
{% endfor %}

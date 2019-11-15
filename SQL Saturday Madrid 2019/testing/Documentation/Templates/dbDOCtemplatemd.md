![](http://www.solidq.com/wp-content/uploads/2015/06/Logo-SolidQ-Web.gif)

# Aba Framework Documentation
## Database doc

* [Info](#head_info)
* [Tables](#head_tables)
  {% for table in tables%}* [{{table.schema}}.{{table.name}}](#{{table.schema}}.{{table.name | replace: '\$', '_'}})
  {% endfor %}
* [Views](#head_views)
  {% for table in views%}* [{{table.schema}}.{{table.name}}](#{{table.schema}}.{{table.name | replace: '\$', '_'}})
  {% endfor %}

## Info <a name='head_info'>
**{{name}}**

DB Info:

| Name | Size | Owner | id | Created | Status | Compatibility level |
| ---- | ---- | ----- | -- | ------- | ------ | ------------------- |
| {{name}} | {{db_size}}| {{owner}}| {{dbid}}| {{created}} | {{status}} | {{compatibility_level}} |

Files:

| Name | id | filename | filegroup | size | maxsize | growth |
| ---- | -- | -------- | --------- | ---- | ------- | ------ |
{% for file in files%}| {{file.Name}} | {{file.id}} | {{file.filename}} | {{file.filegroup}} | {{file.size}} | {{file.maxsize}} | {{file.growth}} |
{% endfor %}
### Tables <a name='head_tables'>
{% for table in tables%}
#### {{table.schema}}.{{table.name}} <a name='{{table.schema}}.{{table.name | replace: '\$', '_'}}'>

Table info:

| Table name | Schema | Owner | Creation date | Rows |
| ---------- | ------ | ----- | ------------- | ---- |
| {{table.name}} | {{table.schema}} | {{table.owner}} | {{table.created_datetime}} | {{table.rows}} |

Columns:

| Columnn name | Type | Length | Nullable | Collation | TrimTrailingBlanks |
| ------------ | ---- | ------ | -------- | --------- | ------------------ |
{% for column in table.columns %}| {{column.name}} | {{column.type}} | {{column.length}} | {{column.nullable}} | {{column.collation}} | {{column.trim}} |
{% endfor %}

Unit tests:

| Execution id | Test name | Execution date | Result | Message |
| ------------ | --------- | -------------- | ------ | ------- |
{% for test in table.tests -%}  | {{test.id}}  | {{test.test_name}}  | {{test.execution_date}}  | {{test.current_error_status_desc}} | {% if test.current_error_status_desc == 'Error' %}[See message](#head_test_{{test.id}}) | {% else %} | |{% endif %}
{% endfor -%}

Errors:
{% for test in table.tests -%}
{% if test.current_error_status_desc == 'Error' %}
##### Test {{test.test_name}} {#head_test_{{test.id}}}
{% for test_error_message in test.etl_test_result_messages -%}
```json
{{test_error_message.message_information}}
```
{% endfor -%}
{% endif %}
{% endfor -%}

Logs:

| Schema Name | Table Name | Type | Start Date | End Date | Status | Loaded by | Inserted Rows | Updated Rows | Deleted Rows |
| ----------- | ---------- | ---- | ---------- | -------- | ------ | --------- | ------------- | ------------ | ------------ |
{% for log in table.logs -%}| {{log.schema_name}} | {{log.table_name}} | {{log.type}} | {{log.start_date}} | {{log.end_date}} | {{log.status}} | {{log.loaded_by}} | {{log.inserted_rows | remove: "<inserted_rows>"}} | {{log.updated_rows | remove: "<updated_rows>"}} | {{log.deleted_rows | remove: "<deleted_rows>"}} |
{% endfor -%}{% endfor %}

### Views <a name='head_views'>
{% for table in views%}
#### {{table.schema}}.{{table.name}} <a name='{{table.schema}}.{{table.name | replace:'\$', '_'}}'>

View info:

| View name | Schema | Owner | Creation date | Rows |
| --------- | ------ | ----- | ------------- | ---- |
| {{table.name}} | {{table.schema}} | {{table.owner}} | {{table.created_datetime}} | {{table.rows}} |

Columns:

| Columnn name | Type | Length | Nullable | Collation | TrimTrailingBlanks |
| ------------ | ---- | ------ | -------- | --------- | ------------------ |
{% for column in table.columns %}| {{column.name}} | {{column.type}} | {{column.length}} | {{column.nullable}} | {{column.collation}} | {{column.trim}} |
{% endfor %}

Creation SQL Script:
```
{% for scriptROW in table.view_creation_sql %}{{scriptROW}}
{% endfor %}```
{{table.view_Text}}


{% endfor %}

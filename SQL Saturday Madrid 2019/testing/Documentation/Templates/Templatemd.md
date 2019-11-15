
![](http://www.solidq.com/wp-content/uploads/2015/06/Logo-SolidQ-Web.gif)

# ABA Framework Documentation
* [Home](#home)
* [Extraction phase](#head_extraction_phase)
  * [Loaded tables](#head_loaded_tables)
  * [Connections](#head_connections)
  * [Load patterns](#head_load_patterns)
  * [Data types source vs stg](#head_data_types_source_vs_stg)
  * [Source Primary keys](#head_source_primary_keys)
  * [Active for](#head_active_for)
* [Load phase](#head_load_phase)
  * [Dimensions](#head_dimensions)
  * [Fact tables](#head_fact_tables)
  * [SCD](#head_scd)
* [Unit Tests](#head_unit_tests)
* [Log Table](#head_log_table)

### Home
Documentation generated using the metadata from {{Name}} database.

_Documentation created: {{date}}_

### Extraction phase <a name='head_extraction_phase'>
####  Loaded Tables <a name='head_loaded_tables'>
| Source object schema | Source object name | Destination table schema | Destination table name | Source type id | Helper id |
| -------------------- | ------------------ | ------------------------ | ---------------------- | -------------- | --------- |
{% for objects in extract_phase_info_objects  %}| '{{objects.source_object_schema}}' | {% if objects.source_type_id == 'VIW'  %}[{{objects.source_object_name |downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% else %}[{{objects.source_object_name |downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% endif %} | {{objects.destination_table_Schema}} | [{{objects.destination_table_name |downcase}}](ResultMetadata_STG{{objects.STG_Id}}.md#{{objects.destination_table_Schema | downcase}}.{{objects.destination_table_name}}) | {{objects.source_type_id}} | {{objects.Helper_Id}} |
{% endfor %}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.extract_phase_info

[Wiki Extraction Phase]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/extraction)

####  Connections <a name='head_connections'>
| Connection name | Connection string | DB Schemas |
| --------------- | ----------------- | -----------|
{% for connection in Connections  %}| {% if connection.Connection_Type == 'HLP' or connection.Connection_Type == 'STG' or connection.Connection_Type == 'DWH' %}[{{connection.Connection_Type}}-{{connection.connection_id}}](ResultMetadata_{{connection.Connection_Type}}{{connection.connection_Id}}.md){% else %}[{{connection.Connection_Type}}-{{connection.connection_id}}](ResultMetadata_{{connection.Connection_Type}}.md){% endif %} | {{connection.Connection_String}} | {{connection.db_schemas}} |
{% endfor %}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.Connections

####  Load patterns <a name='head_load_patterns'>
| Source object schema | Source object name | Load pattern id | Load pattern |
| -------------------- | ------------------ | --------------- | ------------ |
{% for objects in extract_phase_info_objects  %}| {{objects.source_object_schema}}{% if objects.source_type_id == 'VIW'  %} | [{{objects.source_object_name | downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% else %}[{{objects.source_object_name | downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% endif %} | {{objects.load_pattern_id}} | [{{objects.load_pattern}}]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/patterns/#{{objects.load_pattern_id | downcase}}) |
{% endfor %}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.Source_Schema

####  Data types source vs stg <a name='head_data_types_source_vs_stg'>
| Helper id | Table schema name | Table name | Column name | Destination column name | Data type | Destination data type | Different data type |
| --------- | ----------------- | ---------- | ----------- | ----------------------- | --------- | --------------------- |-------------------- |
{% for objects in extract_phase_info_objects -%}{% for schemas in objects.Source_schemas -%}| {{schemas.Helper_Id}} | {{schemas.table_schema_name}} | {{schemas.Table_Name}} | {{schemas.Column_Name}} | {{schemas.Destination_Column_Name}} | {{schemas.Data_Type}} | {{schemas.Destination_Data_Type}} | {{schemas.Different_Data_Type}} |
{% endfor %}{% endfor -%}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.Source_Schema

####  Source Primary Keys <a name='head_source_primary_keys'>
| Source object Schema | Source object name | Primary key columns |
| -------------------- | ------------------ | ------------------- |
{% for objects in extract_phase_info_objects  %}| {{objects.source_object_schema}} |{% if objects.source_type_id == 'VIW'  %}[{{objects.source_object_name |downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% else %}[{{objects.source_object_name |downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% endif %} | {{objects.primary_key_columns}} |
{% endfor %}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.extract_phase_info

[Wiki E Phase naming conventions]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/naming-conventions#extraction)

####  Active for load creation orquestator <a name='head_active_for'>
| Source object schema | Source object name | Active for load | Active for creation | Active for orquestator |
| -------------------- | ------------------ | --------------- | ------------------- | ---------------------- |
{% for objects in extract_phase_info_objects  %}| {{objects.source_object_schema}}{% if objects.source_type_id == 'VIW'  %} | [{{objects.source_object_name |downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% else %}[{{objects.source_object_name |downcase}}](ResultMetadata_HLP{{objects.Helper_Id}}.md#{{objects.source_object_schema | downcase}}.{{objects.source_object_name}}){% endif %} | {{objects.active_for_load}} | {{objects.active_for_creation}} | {{objects.active_for_orquestator}}
{% endfor %}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.extract_phase_info

[Wiki Extraction Phase Info columns]({{wiki_url | replace: ' ', '%20'}}/framework-databases#epi)

### Load phase <a name='head_load_phase'>
####  Dimensions <a name='head_dimensions'>
| Source table name | Destination table name | Active for creation | Active for load | Primary key columns | Detect deletes | Order group |
| ----------------- | ---------------------- | ------------------- | --------------- | ------------------- | -------------- | ----------- |
{%  for dims in dim_objects  -%}| [{{dims.source_table_name}}](ResultMetadata_STG{{facts.stg_id}}.md#etl{{dims.source_schema}}.{{dims.source_table_name | url_encode | replace:'%','_'}}) | [{{dims.destination_table_name}}](ResultMetadata_DWH{{facts.dwh_id}}.md#dim{{dims.destination_table_name | url_encode | replace:'%','_'}}) | {{dims.active_for_creation}} | {{dims.active_for_load}} | {{dims.primary_key_columns}} | {{dims.Detect_Deletes}} | {{dims.Order_Group}} |
{% endfor %}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.dimension_load_phase_info

[Wiki Loading Phase]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/load)

[Wiki Naming Conventions Loading Phase]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/naming-conventions#load)

####  Fact tables <a name='head_fact_tables'>
| Source table name | Destination table name | Active for creation | Active for load | Primary key columns | Detect deletes | Order group |
| ----------------- | ---------------------- | ------------------- | --------------- | ------------------- | -------------- | ----------- |
{%  for facts in fact_objects  -%}| [{{facts.source_table_name}}](ResultMetadata_STG{{facts.stg_id}}.md#etl{{facts.source_schema}}.{{facts.source_table_name | url_encode | replace:'%','_'}}) | [{{facts.destination_table_name}}](ResultMetadata_DWH{{facts.dwh_id}}.md#dim.{{facts.destination_table_name | url_encode | replace:'%','_'}}) | {{facts.active_for_creation}} | {{facts.active_for_load}} | {{facts.primary_key_columns}} | {{facts.Detect_Deletes}} | {{facts.Order_Group}} |
{% endfor %}
**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.load_phase_info

[Wiki Loading Phase]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/load)

[Wiki Naming Conventions Loading Phase]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/naming-conventions#load)

####  SCD <a name='head_scd'>
| Source table name | Destination column name | Change type | Type description |
| ----------------- | ----------------------- | ----------- | ---------------- |
{% for dims in dim_objects -%}{% for col in dims.dim_columns -%}| [{{col.source_table_name}}](ResultMetadata_STG{{facts.stg_id}}.md#etl{{col.source_table_name | url_encode | replace:'%','_'}}) | {{col.source_column_name}} | {{col.change_Type}} | {{col.type_description}} |
{% endfor %}{% endfor %}

**Information Source DB:** {{Name}}_MD

**Information Source Table:** md.dimensions_load_phase_info_columns

[Wiki Slowly Change Dimensions]({{wiki_url | replace: ' ', '%20'}}/etl-with-aba-framework/load#scd)


### Unit Tests <a name='head_unit_tests'>
| Execution id | Test name  | Source schema | Table name | Execution date | Result | Message |
| ------------ | ---------- | ------------- | ---------- | -------------- | ------ | ------- |
{% for test in tests_objects -%}| {{test.id}} | {{test.test_name}} | {{test.source_schema}} | {{test.table_name}} | {{test.execution_date}} | {{test.current_error_status_desc}} | {% if test.current_error_status_desc == 'Error' %}[See message](#head_test_{{test.id}}) | {% else %} |{% endif %}
{% endfor %}

#### Test Results
{%for test in tests_objects -%}
{% if test.current_error_status_desc == 'Error' %}
##### Test {{test.test_name}} {#head_test_{{test.id}}}

{% for test_error_message in test.etl_test_result_messages -%}
```json
{{test_error_message.message_information}}
```
{% endfor -%}
{% endif %}
{% endfor %}

[Wiki Unit Tests]({{wiki_url | replace: ' ', '%20'}}/automatedtesting/#main_characteristics)

### Log Table <a name='head_log_table'>
| Schema name | Name of the table | Type | Start date | End date | Status | Loaded by | Inserted rows | Updated rows | Deleted rows | Project Name | HLP ID | STG ID | Package Name |
| ----------- | ----------- | ---- | ---------- | -------- | ------ | --------- | ------------- | ------------ | ------------ | ------------ | ------ | ------ | ------------ |
{% for logs in etl_objects -%}| {{logs.schema_name}} | {{logs.table_name}} | {{logs.type}} | {{logs.start_date}} | {{logs.end_date}} | {{logs.status}} | {{logs.loaded_by | replace: '\\', '\\'}} | {{logs.inserted_rows}} | {{logs.updated_rows}} | {{logs.deleted_rows}} | {{logs.project_name}} | {{logs.hlp_id}} | {{logs.stg_id}} | {{logs.package_name | replace: '_', ' \_ '}} |
{% endfor %}

[Wiki LOG Database]({{wiki_url | replace: ' ', '%20'}}/framework-databases#log-database)
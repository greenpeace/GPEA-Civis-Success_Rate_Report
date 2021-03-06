---Monthcount import: https://platform.civisanalytics.com/spa/#/imports/23588454
---Staging table import: https://platform.civisanalytics.com/spa/#/imports/13823492
---GPEA Universe Workflow: https://platform.civisanalytics.com/spa/#/workflows/2958
---Analytics extract tables create: https://platform.civisanalytics.com/spa/#/scripts/sql/20929562


----Report_RetentionReport1
CREATE TEMP TABLE RetentionReport1 AS 
select * from
(select a.rgid,a.region,a.contactid,c.constituentid,a.signupyear,a.signupmonth,a.signupdate,a.firstpaymentdate,d.monthcount,b.programme,b.resource,b.team,b.name,a.recruiter,c.agebandrgsignup as AgeGroup, a.paymentmethod,a.rgstatus,d.active,a.fixeddonationperiod,a.delaydonation,a.bothfixeddelay from 
gpea_analytics.extract_regulargiving a
left join gpea_analytics.extract_campaign b on a.campaignid=b.campaignid
inner join gpea_analytics.extract_contact c on a.contactid=c.contactid
cross join
(select * from gpea_staging.monthcount where active=1) d
where a.signupyear>=2014);

----Report_RetentionReport2
CREATE TEMP TABLE RetentionReport2 AS 
select * from
(select a.rgid,a.signupyear,a.signupmonth,a.signupdate,a.contactid, DATEDIFF(month, a.signupdate, b.debitdate) + 1 as MonthCount1,
DATEDIFF(month, a.FirstPaymentDate, b.DebitDate) + 1 as MonthCount2, b.amount from
gpea_analytics.extract_regulargiving a
inner join
(select * from gpea_analytics.extract_opportunity where success=1) b on a.rgid=b.rgid);

----Report_RetentionReport3
CREATE TEMP TABLE RetentionReport3 AS 
select * from
(select a.rgid,a.region,a.contactid,a.constituentid,a.signupyear,a.signupmonth,a.signupdate,a.name,
CASE WHEN a.Programme = 'DDC' OR a.Programme = 'Web' OR a.Programme = 'Telephone' OR a.Programme = 'Reactivation' THEN a.Programme ELSE 'Others' END as Source,
a.resource, a.team,a.recruiter,a.agegroup,a.paymentmethod, a.rgstatus,a.fixeddonationperiod,a.delaydonation,a.bothfixeddelay,a.monthcount,
CASE WHEN getdate() >= dateadd(month , a.MonthCount , TO_DATE(TO_CHAR(a.SignUpYear,'0000')||'-'||TO_CHAR(date_part(month,a.SignUpDate),'00')||'-'||TO_CHAR(01,'00'), ' YYYY- MM- DD')) THEN CASE WHEN b.RGID IS NULL THEN 0.00 ELSE 1.00 END ELSE NULL END as Success,
CASE WHEN a.MonthCount = 1 THEN 1.00 ELSE 0.00 END as SignUpCount, 
CASE WHEN datediff(month , a.SignUpDate , getdate()) <= 1 THEN NULL ELSE CASE WHEN datediff(month , a.SignUpDate , a.FirstPaymentDate) <= 3 THEN 0.00 ELSE 1.00 END END as Predebit from
RetentionReport1 a
left join RetentionReport2 b on a.rgid=b.rgid and a.monthcount=b.monthcount1)
where success is not null;

----KR data regenerate
create temp table retentionreportKR as
select * from
(
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 1 as monthcount,to_number("1",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 2 as monthcount,to_number("2",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 3 as monthcount,to_number("3",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 4 as monthcount,to_number("4",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 5 as monthcount,to_number("5",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 6 as monthcount,to_number("6",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr  
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 7 as monthcount,to_number("7",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr  
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 8 as monthcount,to_number("8",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 9 as monthcount,to_number("9",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 10 as monthcount,to_number("10",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr  
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 11 as monthcount,to_number("11",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr  
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 12 as monthcount,to_number("12",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr  
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 13 as monthcount,to_number("13",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr  
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 14 as monthcount,to_number("14",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr 
 union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 15 as monthcount,to_number("15",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr 
  union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 16 as monthcount,to_number("16",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr 
  union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 17 as monthcount,to_number("17",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr 
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 18 as monthcount,to_number("18",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr 
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 19 as monthcount,to_number("19",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr 
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 20 as monthcount,to_number("20",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr 
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 21 as monthcount,to_number("21",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 22 as monthcount,to_number("22",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 23 as monthcount,to_number("23",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 24 as monthcount,to_number("24",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 36 as monthcount,to_number("36",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
union all
select '' as rgid,'Korea' as region, '' as contactid, constituent_id as constituentid, year as signupyear, month as signupmonth, to_date("join date",'YYYY-MM-DD') as signupdate,'' as name, source, subsource as resource, '' as team, '' as recruiter, '' as agegroup, '' as paymentmethod, '' as rgstatus, 0 as fixeddonationperiod, 0 as delaydonation, 0 as bothfixeddelay, 48 as monthcount,to_number("48",'99.99999') as success, 0 as signupcount, 0 as predebit from gpea_reporting.table_report_Success_Rate_kr
);


----create_table
DROP TABLE if exists gpea_reporting.table_report_Success_Rate; 
CREATE TABLE gpea_reporting.table_report_Success_Rate AS (
select * from RetentionReport3
union all
select * from retentionreportKR);


-- GRANT Statements for GPEA Group
GRANT ALL ON SCHEMA gpea_analytics TO GROUP gpea;
GRANT ALL ON SCHEMA gpea_staging TO GROUP gpea;
GRANT ALL ON SCHEMA gpea_reporting TO GROUP gpea;
GRANT ALL ON SCHEMA public TO GROUP gpea;
GRANT ALL ON gpea_reporting.table_report_Success_Rate TO GROUP gpea;
GRANT ALL ON gpea_staging.monthcount TO GROUP gpea;

GRANT ALL ON gpea_analytics.extract_campaign TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_contact TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_opportunity TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_regulargiving TO GROUP gpea;

GRANT ALL ON gpea_staging.kr_supporter_alc TO GROUP gpea;
GRANT ALL ON gpea_staging.kr_income_account TO GROUP gpea;
GRANT ALL ON gpea_staging.kr_upgrade_monthly TO GROUP gpea;
GRANT ALL ON gpea_staging.kr_downgrade_monthly TO GROUP gpea;
GRANT ALL ON gpea_staging.currency_conversion TO GROUP gpea;

GRANT ALL ON gpea_analytics.extract_2017budget_income TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_2018budget_income TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_2018budget_supporter TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_2019budget_income TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_2019budget_supporter TO GROUP gpea;
GRANT ALL ON gpea_analytics.extract_budget_recode_group TO GROUP gpea;


-- GRANT Statements for GPEA Robot User
GRANT ALL ON SCHEMA gpea_analytics TO greenpeaceearobot;
GRANT ALL ON SCHEMA gpea_staging TO greenpeaceearobot;
GRANT ALL ON SCHEMA gpea_reporting TO greenpeaceearobot;
GRANT ALL ON SCHEMA public TO greenpeaceearobot;
GRANT ALL ON gpea_reporting.table_report_Success_Rate TO greenpeaceearobot;
GRANT ALL ON gpea_staging.monthcount TO greenpeaceearobot;


GRANT ALL ON gpea_analytics.extract_campaign TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_contact TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_opportunity TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_regulargiving TO greenpeaceearobot;

GRANT ALL ON gpea_staging.kr_supporter_alc TO greenpeaceearobot;
GRANT ALL ON gpea_staging.kr_income_account TO greenpeaceearobot;
GRANT ALL ON gpea_staging.kr_upgrade_monthly TO greenpeaceearobot;
GRANT ALL ON gpea_staging.kr_downgrade_monthly TO greenpeaceearobot;
GRANT ALL ON gpea_staging.currency_conversion TO greenpeaceearobot;

GRANT ALL ON gpea_analytics.extract_2017budget_income TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_2018budget_income TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_2018budget_supporter TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_2019budget_income TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_2019budget_supporter TO greenpeaceearobot;
GRANT ALL ON gpea_analytics.extract_budget_recode_group TO greenpeaceearobot;

-- GRANT Statements for Civis Group
GRANT ALL ON SCHEMA gpea_analytics TO GROUP civis;
GRANT ALL ON SCHEMA gpea_staging TO GROUP civis;
GRANT ALL ON SCHEMA gpea_reporting TO GROUP civis;
GRANT ALL ON SCHEMA public TO GROUP civis;
GRANT ALL ON gpea_reporting.table_report_Success_Rate TO GROUP civis;
GRANT ALL ON gpea_staging.monthcount TO GROUP civis;

GRANT ALL ON gpea_analytics.extract_campaign TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_contact TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_opportunity TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_regulargiving TO GROUP civis;

GRANT ALL ON gpea_staging.kr_supporter_alc TO GROUP civis;
GRANT ALL ON gpea_staging.kr_income_account TO GROUP civis;
GRANT ALL ON gpea_staging.kr_upgrade_monthly TO GROUP civis;
GRANT ALL ON gpea_staging.kr_downgrade_monthly TO GROUP civis;
GRANT ALL ON gpea_staging.currency_conversion TO GROUP civis;

GRANT ALL ON gpea_analytics.extract_2017budget_income TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_2018budget_income TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_2018budget_supporter TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_2019budget_income TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_2019budget_supporter TO GROUP civis;
GRANT ALL ON gpea_analytics.extract_budget_recode_group TO GROUP civis;

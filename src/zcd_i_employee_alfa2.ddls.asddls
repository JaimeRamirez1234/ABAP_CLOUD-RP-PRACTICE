@AbapCatalog.sqlViewName: 'ZV_EMPL_ALFA02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Employee'
@Metadata.ignorePropagatedAnnotations: true
define root view ZCD_I_EMPLOYEE_ALFA2
  as select from zemployee_alfa02  as Employee
{
  key e_number,
      e_name,
      e_department,
      status,
      job_title,
      start_date,
      end_date,
      email,
      m_number,
      m_name,
      m_department,
      crea_date_time,
      crea_uname,
      lchg_date_time,
      lchg_uname
}

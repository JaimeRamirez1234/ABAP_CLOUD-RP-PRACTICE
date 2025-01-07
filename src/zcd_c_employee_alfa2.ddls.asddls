@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Employee'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCD_C_EMPLOYEE_ALFA2
as projection on ZCD_I_EMPLOYEE_ALFA2
{
    //@ObjectModel.text.element: [ 'EmployeeName' ]
  key e_number       as EmployeeNumber,
      e_name         as EmployeeName,
      e_department   as EmployeeDepartment,
      status         as EmployeeStatus,
      job_title      as JobTitle,
      start_date     as StartDate,
      end_date       as EndDate,
      email          as Email,
      //@ObjectModel.text.element: [ 'ManagerName' ]
      m_number       as ManagerNumber,
      m_name         as ManagerName,
      m_department   as ManagerDepartment,
      @Semantics.user.createdBy: true
      crea_uname     as CreatedBy,
      crea_date_time as CreatedOn,
      @Semantics.user.lastChangedBy: true
      lchg_uname     as ChangedBy,
      lchg_date_time as ChangedOn   
}

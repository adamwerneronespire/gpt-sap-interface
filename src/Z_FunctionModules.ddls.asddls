@EndUserText.label: 'Function modules (active)'
@AbapCatalog.sqlViewName: 'ZV_FM_META'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_FunctionModules
  as select from tfdir
    left outer join enlfdir on enlfdir.funcname = tfdir.funcname
    left outer join tftit   on tftit.funcname   = tfdir.funcname
  association [0..*] to Z_FM_Parameters as _Parameters
    on $projection.funcname = _Parameters.funcname
{
  key tfdir.funcname            as funcname,
      tfdir.fmode               as fmode,
      tfdir.utask               as utask,
      enlfdir.active            as active,
      enlfdir.generated         as generated,
      tftit.stext               as stext,
      _Parameters
}
where enlfdir.active = 'X';


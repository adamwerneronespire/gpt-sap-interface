@EndUserText.label: 'Function module parameters (active)'
@AbapCatalog.sqlViewName: 'ZV_FM_PARAM'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_FM_Parameters
  as select from fupararef
{
  key funcname,
  key parameter,
  key paramtype,     // I/E/C/T
      structure,
      defaultval,
      optional,
      reference,
      r3state
}
where r3state = 'A';

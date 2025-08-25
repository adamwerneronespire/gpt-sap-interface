@EndUserText.label: 'Domain Values (active)'
@AbapCatalog.sqlViewName: 'ZV_DOM_VAL'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_Domain_Values
  as select from dd07v
{
  key domname,
  key domvalue_l,
      ddlanguage,
      domvalue_h,
      valpos,
      ddtext
}
where as4local = 'A';

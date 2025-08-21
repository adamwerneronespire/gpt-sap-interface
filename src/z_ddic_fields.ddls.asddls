@EndUserText.label: 'DDIC fields'
@AbapCatalog.sqlViewName: 'ZV_DDIC_FLD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_DDIC_Fields
  as select from dd03l
{
  key tabname,
  key fieldname,
      position,
      datatype,
      leng,
      decimals,
      as4local
}
where as4local = 'A';

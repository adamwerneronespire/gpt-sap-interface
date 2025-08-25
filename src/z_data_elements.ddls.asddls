@EndUserText.label: 'Data Elements (active)'
@AbapCatalog.sqlViewName: 'ZV_DTEL_META'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_Data_Elements
  as select from dd04l
{
  key rollname,
      ddlanguage,
      domname,
      datatype,
      leng,
      decimals,
      scrtext_s,
      scrtext_m,
      scrtext_l,
      reptext,
      applclass,
      dtelmasterlang as masterlang,
      as4local,
      as4date
}
where as4local = 'A';

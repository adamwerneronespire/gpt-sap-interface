@EndUserText.label: 'Domains (active)'
@AbapCatalog.sqlViewName: 'ZV_DOMAIN_META'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_Domains
  as select from dd01l
  association [0..*] to Z_Domain_Values as _Values
    on $projection.domname = _Values.domname
{
  key domname,
      ddlanguage,
      datatype,
      outputlen,
      decimals,
      case_sensitive,
      valexi,
      shorttext,
      _Values
}
where as4local = 'A';

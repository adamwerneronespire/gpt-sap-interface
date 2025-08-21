@EndUserText.label: 'DDIC tables (active)'
@AbapCatalog.sqlViewName: 'ZV_DDIC_TBL'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_DDIC_Tables
  as select from dd02l
  association [0..*] to Z_DDIC_Fields as _Fields
    on $projection.tabname = _Fields.tabname
{
  key tabname,
      tabclass,
      as4local,
      as4date,
      ddtext,
      _Fields                             // expose assoc for $expand
}
where as4local = 'A';

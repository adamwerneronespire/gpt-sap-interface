@EndUserText.label: 'Active CDS sources (name + SQL view)'
@AbapCatalog.sqlViewName: 'ZV_CDS_SRC'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_CDS_Sources
  as select from ddddlsrc
{
  key ddlname,
      sqlviewname,
      package_name,
      created_by,
      created_on
}
where state = 'A';

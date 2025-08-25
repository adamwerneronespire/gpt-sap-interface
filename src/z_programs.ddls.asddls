@EndUserText.label: 'Programs (active)'
@AbapCatalog.sqlViewName: 'ZV_TRDIR'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_Programs
  as select from trdir
{
  key name,
      subc,
      appl,
      uccheck,
      fixpt,
      varcl,
      state,
      createdon,
      autor
}

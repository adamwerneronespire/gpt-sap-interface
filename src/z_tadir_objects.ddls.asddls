@EndUserText.label: 'Repository Objects (TADIR)'
@AbapCatalog.sqlViewName: 'ZV_TADIR_OBJ'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_TADIR_Objects
  as select from tadir
{
  key pgmid,
  key object,
  key obj_name,
      devclass,
      author,
      srcsystem,
      srcdep,
      created_on,
      corrnum
}

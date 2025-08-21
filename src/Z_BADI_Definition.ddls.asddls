@EndUserText.label: 'BAdI definitions (classic)'
@AbapCatalog.sqlViewName: 'ZV_BADI_DEF'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_BADI_Definition
  as select from sxc_exit
    left outer join sxc_attr on sxc_attr.exit_name = sxc_exit.exit_name
{
  key sxc_exit.exit_name,
      sxc_exit.interface,
      sxc_attr.devclass,
      sxc_attr.active,
      sxc_attr.description
};


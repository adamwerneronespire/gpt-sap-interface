@EndUserText.label: 'Message Texts (T100)'
@AbapCatalog.sqlViewName: 'ZV_T100'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z_Message_Texts
  as select from t100
{
  key sprsl,
  key arbgb,
  key msgnr,
      text
}

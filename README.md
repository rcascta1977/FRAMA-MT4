# FRAMA-MT4
Es un indicador para Metatrader 4 (archivo MQ4) que traza una media móvil FRAMA (Media Móvil Adaptativa Fractal) en cualquier gráfico de precios.

La FRAMA es una media móvil adaptativa creada por John Ehlers que le da mayor peso a los movimientos de precios más significativos y recientes, de tal manera que reacciona menos 
a las oscilaciones de precios menores (ruido del mercado).

Esa media móvil aprovecha la naturaleza fractal de los movimientos del mercado.

En este indicador el usuario puede seleccionar el periodo de cálculo de la media móvil (el valor por defecto es 10 periodos) y el tipo de precio (el valor por defecto es Close o precio de cierre).

![media-movil-frama](https://github.com/rcascta1977/FRAMA-MT4/assets/41598217/6497d409-ec0e-4279-adb1-2db97af3fa1d)

Pueden encontrar instrucciones más detalladas sobre la instalación y uso de este indicador en: https://www.tecnicasdetrading.com/2019/08/media-movil-frama-para-metatrader.html

<h2>Mejoras planeadas</h2>
Las mejoras planeadas para este indicador incluyen:
<ul>
  <li>Señales de cruces del precio con la FRAMA.</li>
  <li>Cambio de color cuando la FRAMA presenta una tendencia alcista o bajista.</li>
  <li>Un tablero de señales para múltiples instrumentos y marcos de tiempo.</li>
</ul>

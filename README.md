# IngenieroDevOps

Sección 1: Conocimientos Generales AWS (10 puntos)

1. Describe la diferencia entre regiones, zonas de disponibilidad y edge locations en AWS.

  * Las regiones son areas extensas lo podriamos llamar como Bogota donde se compone minimo de 3 Zonas de disponibilida que pueden estar instaladas en el Norte , Centro y Sur de la ciudad, 
    conectadas sobre anillos de fribra Optica a gran velocidad y alta disponibilidad si una Zona falla Ejemplo "la del Centro sucede que los servicios que estan en las otras zonas sea Norte y Sur 
    van a estar funcionando sin problema" , en si la jerargia las Zonas de Disponibilidad conforman una region, Los Edge Locations que se configurar por medio de los CloudFrondt "CN" Son como 
    puntos de entrega más cercanos a los usuarios, ¡están por todo el mundo! Así la información llega más rápido a la gente.

2. ¿Qué servicios de AWS utilizarías para implementar una aplicación web de tres capas
(frontend, backend, base de datos)? Justifica tu elección.

   * Para mi aplicación de tres capas, usaría:

   * Para el frontend, pondría los archivos estáticos (HTML, CSS, JavaScript) en Amazon S3. ¡Es barato y aguanta mucho tráfico! Y para que vaya súper rápido a los usuarios, usaría Amazon 
     CloudFront para distribuirlo desde los edge locations.
     
   * Para el backend, me iría por AWS Elastic Beanstalk. Así no me preocupo tanto por los servidores y puedo enfocarme en mi código en Python. O si uso Docker, quizás Amazon ECS o AWS Fargate 
     serían mejor para manejar los contenedores "Microservicios". También podría usar AWS Lambda para algunas funciones pequeñas sin tener que pensar en servidores. Y para que el frontend hable 
     con el backend, usaría Amazon API Gateway.
  
    * Para la base de datos, si es algo relacional, Amazon RDS es muy rentable. Me da un montón de opciones como PostgreSQL o MySQL y AWS se encarga de la mayoría del trabajo pesado. Si necesito 
      algo más flexible y que escale mucho, Amazon DynamoDB  que es una BD no Relacional, sería mi elección.


4. Explica la diferencia entre una instancia de EC2 spot, on-demand y reserved. ¿Cuándo
utilizarías cada una?

     * las instancias on-demand son como alquilar un carro por horas, pagas por lo que se usa y no se tiene ningún compromiso. Las uso cuando no sé cuánto tiempo voy a necesitar algo o si hay 
       picos de trabajo.

      * Las reserved son como un contrato de arrendamiento de un carro por uno o tres años. Paga menos a largo plazo si se va a necesitar esa instancia todo el tiempo, como para mis 
       servidores web que siempre están activos.

      *las spot son como prestadas por precios muy bajos,  Pero tienen la dependencia que si AWS las necesita de vuelta o el precio sube, las quitan con poco aviso. Las uso para cosas que pueden 
       interrumpirse y reiniciarse sin problema.


6. Describe qué es IAM en AWS y menciona 3 mejores prácticas para gestionar permisos de
forma segura.

      1)  Dar solo los permisos necesarios: Nada de darle acceso a todo a todo el mundo. Solo lo justo para que hagan su trabajo.
      2)  Usar roles para las aplicaciones: En lugar de poner claves secretas en el código, le doy un "rol" a la instancia EC2 o al servicio para que pueda acceder a otros recursos de forma segura.
      3)  Activar el MFA: ¡Autenticación multifactor para todos! Así, aunque alguien consiga mi contraseña, necesita ese código extra de mi teléfono para entrar.





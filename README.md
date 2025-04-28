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
         

 Sección 2: Linux y Scripting (10 puntos) 

**1. Escribe un script en bash que monitoree el espacio en disco y envíe una alerta si supera el 80% de uso.**

```bash
#!/bin/bash

# Se Define el punto de montaje a monitorear y el umbral de uso
MONITOR_PATH="/"
THRESHOLD=80

# Obtiene el uso actual del disco en porcentaje
USE_PERCENT=$(df -h "$MONITOR_PATH" | awk 'NR==2 {print $5}' | sed 's/%//')

# Comprueba si el uso supera el umbral
if [ "$USE_PERCENT" -gt "$THRESHOLD" ]; then
  # Define el asunto y el cuerpo del correo electrónico
  SUBJECT="ALERTA: ¡Espacio en disco crítico!"
  BODY="El espacio en disco en $MONITOR_PATH ha superado el $THRESHOLD% de uso. El uso actual es del $USE_PERCENT%."
  RECIPIENT="tu_correo@example.com" # Reemplaza con tu dirección de correo

  # Envía la alerta por correo electrónico (asegúrate de tener configurado un MTA como sendmail o postfix)
  echo "$BODY" | mail -s "$SUBJECT" "$RECIPIENT"

  echo "¡Alerta enviada por correo electrónico!"
fi

echo "Uso de disco en $MONITOR_PATH: $USE_PERCENT%"
```

Este script primero define la ruta que quiero vigilar (`/` en este caso) y el porcentaje límite (`80`). Luego, usa `df -h` para obtener la información del disco, `awk` para extraer la columna del porcentaje de uso y `sed` para quitar el símbolo `%`. Después, compara ese porcentaje con mi límite. Si lo supera, prepara un correo electrónico con el asunto y el mensaje de alerta, y lo envía a mi correo. Finalmente, siempre muestra el uso actual del disco. ¡Así me mantengo al tanto!

**2. Describe qué hace el siguiente comando y cómo lo mejorarías:**

```bash
ps -ef | grep java | awk '{print $2}' | xargs kill -9
```

Este comando lo que hace es:

* **`ps -ef`**: Lista todos los procesos que se están ejecutando en el sistema, mostrando información detallada sobre cada uno.
* **`grep java`**: Filtra la salida de `ps -ef` y muestra solo las líneas que contienen la palabra "java". Esto en teoría me da los procesos relacionados con Java.
* **`awk '{print $2}'`**: Toma la salida de `grep java` y extrae la segunda columna de cada línea, que generalmente contiene el Process ID (PID).
* **`xargs kill -9`**: Toma los PIDs que le pasa `awk` y ejecuta el comando `kill -9` en cada uno de ellos. `kill -9` es una señal para terminar un proceso de forma inmediata y forzada.

**¿Cómo lo mejoraría?**

Este comando es un poco peligroso porque puede matar procesos que contengan "java" en su nombre o argumentos pero que no sean realmente los procesos que quiero terminar. Lo mejoraría haciéndolo más específico:

* **Usar `pgrep` o `pkill`:** Estas herramientas están diseñadas específicamente para buscar procesos por su nombre. Podría usar `pgrep java` para obtener los PIDs de los procesos llamados "java" de forma más segura. Incluso `pkill -9 java` haría todo en un solo comando.

* **Ser más específico con el nombre del proceso:** Si sé el nombre exacto del proceso Java que quiero matar, lo usaría en lugar de solo "java" en el `grep` o con `pgrep`. Por ejemplo, `grep "mi_aplicacion_java.jar"` o `pgrep mi_aplicacion_java.jar`.

* **Verificar los PIDs antes de matar:** Podría añadir un paso intermedio para mostrar los PIDs encontrados y pedir confirmación antes de ejecutar el `kill -9`.

* **Usar señales menos agresivas primero:** En lugar de `kill -9` directamente, intentaría con `kill -15` (SIGTERM) primero, que le da al proceso la oportunidad de cerrarse limpiamente. Si no responde después de un tiempo, entonces consideraría usar `kill -9`.

Así, un comando mejorado podría ser algo como:

```bash
pkill -9 "nombre_especifico_del_proceso_java"
```

O, con verificación y señal menos agresiva:

```bash
pids=$(pgrep "nombre_especifico_del_proceso_java")
if [ -n "$pids" ]; then
  echo "Se encontraron los siguientes PIDs de Java: $pids"
  read -p "¿Desea terminarlos? (s/n): " confirm
  if [ "$confirm" == "s" ]; then
    kill "$pids" # Intenta con SIGTERM primero
    sleep 5 # Espera un poco
    # Vuelve a verificar si siguen corriendo y si es necesario usa SIGKILL
    pids_remaining=$(pgrep "nombre_especifico_del_proceso_java")
    if [ -n "$pids_remaining" ]; then
      echo "Algunos procesos no se cerraron, enviando SIGKILL..."
      kill -9 "$pids_remaining"
    fi
  fi
fi
```

**3. Explica cómo automatizarías un backup diario de archivos en un servidor Linux y su transferencia a un bucket S3 de AWS.**

Para automatizar un backup diario y subirlo a S3, haría lo siguiente:

a.  **Crear un script de backup:** Escribiría un script en bash que se encargue de:
    * Seleccionar los archivos y directorios que quiero respaldar.
    * Crear un archivo comprimido (por ejemplo, con `tar.gz`). Le pondría un nombre que incluya la fecha para tener un historial.
    * Opcionalmente, rotar los backups locales más antiguos para no quedarme sin espacio en el servidor.

    Un ejemplo sencillo de script podría ser:

    ```bash
    #!/bin/bash

    BACKUP_DIR="/opt/backups"
    DATE=$(date +%Y-%m-%d)
    HOSTNAME=$(hostname)
    BACKUP_FILE="$BACKUP_DIR/$HOSTNAME-$DATE.tar.gz"
    FILES_TO_BACKUP="/home /etc /var/log" # Ejemplo de directorios a respaldar

    # Asegura que el directorio de backups exista
    mkdir -p "$BACKUP_DIR"

    # Crea el backup comprimido
    tar -czvf "$BACKUP_FILE" "$FILES_TO_BACKUP"

    echo "Backup creado: $BACKUP_FILE"

    # Aquí vendría la parte de la subida a S3 (en el siguiente paso)
    ```

b.  **Subir el backup a S3:** Utilizaría la AWS CLI (Command Line Interface) para copiar el archivo de backup al bucket de S3. Necesitaría tener configuradas las credenciales de AWS en el servidor (lo ideal sería usar roles de IAM en lugar de claves directamente en el servidor).

    Añadiría esta línea al final de mi script de backup:

    ```bash
    aws s3 cp "$BACKUP_FILE" "s3://mi-bucket-de-respaldos/$HOSTNAME/$DATE.tar.gz"
    echo "Backup subido a s3://mi-bucket-de-respaldos/$HOSTNAME/$DATE.tar.gz"
    ```

c.  **Automatizar la ejecución diaria con Cron:** Configurar una entrada en el crontab del servidor para que el script se ejecute automáticamente todos los días a una hora específica. Por ejemplo, para ejecutarlo a las 2 de la madrugada todos los días, editaría el crontab con `crontab -e` y añadiría la siguiente línea:

    ```cron
    0 2 * * * /ruta/al/mi_script_de_backup.sh
    ```

d.  **Gestionar la retención en S3 (Lifecycle Policies):** Para no acumular backups indefinidamente en S3 y controlar los costos, configuraría políticas de ciclo de vida (Lifecycle Policies) en el bucket de S3. Estas políticas me permitirían especificar cuánto tiempo quiero conservar los backups, cuándo moverlos a un almacenamiento más económico como S3 Glacier, o cuándo eliminarlos por completo.

#Para el laboratorio utilizamos como PLATAFORMA IAC TERRAFORM

Sección 3: Infraestructura como Código (20 puntos) _EC2

*Bloques data
  aws_vpc.vpc_default: Obtiene la VPC por defecto de la región configurada.
  aws_subnet.zd_1s: Obtiene la subred predeterminada de la zona de disponibilidad us-east-1a.
  aws_security_group.default: Obtiene el Security Group por defecto.

*Recursos creados
  EC2 Instance (aws_instance.seccion3):
  Se despliega una instancia t2.micro usando la AMI ami-01816d07b1128cd2d.
  La instancia se asocia a la subred de us-east-1a y al Security Group personalizado sg_seccion3.
  La instancia está etiquetada como Name = seccion3.


*Security Group (aws_security_group.seccion3):
  Se crea un grupo de seguridad que permite tráfico:
  SSH (Puerto 22) desde 192.168.1.0/24.
  HTTP (Puerto 80) desde cualquier origen 0.0.0.0/0.
  HTTPS (Puerto 443) desde cualquier origen 0.0.0.0/0.

*Subnet privada (aws_subnet.subred_privada):
  Se crea una subred privada con el bloque CIDR 172.31.250.0/24 en us-east-1a.
  Tabla de rutas (aws_route_table.mi_tabla_ruta_privada):
  Se crea una tabla de rutas para la VPC por defecto.
  Se asocia esta tabla de rutas con la subred privada creada.


------Intruciones de Despliegue-----------------------
Instrucciones de Despliegue para Infraestructura de Red
Configurar tus credenciales de AWS (AWS CLI o variables de entorno).

*Desde la carpeta terraform/, inicializa Terraform: 
   terraform init

*Despliegar toda la infraestructura

   terraform apply

Confirma los cambios escribiendo YES cuando Terraform lo solicite.

*Al finalizar el despliegue:
 Tu instancia EC2 estará disponible en la subred predeterminada us-east-1a.
 La subred privada estará lista para futuros recursos.


Sección 3: Infraestructura como Código (20 puntos) _S3

Recursos creados:

*Bucket S3 (aws_s3_bucket.bucket):
  Se crea un bucket llamado mi-bucket-ejemplo-lambda-s3 que almacenará los archivos subidos.

*Función Lambda (aws_lambda_function.lambda):
  Función desplegada con el runtime de Python 3.9.
  El código fuente debe estar empaquetado en un archivo .zip (lambda_function_payload.zip).
  El handler definido es index.handler.

*Rol IAM para Lambda (aws_iam_role.lambda_exec):
  Rol que permite a la función Lambda asumir permisos básicos para ejecución.

*Política IAM (aws_iam_role_policy.lambda_policy):
  Otorga permisos para:
  Acceso de lectura (GetObject, ListBucket) sobre el bucket S3.
  Escritura de logs en CloudWatch Logs.

*Permiso de invocación (aws_lambda_permission.allow_s3):
  Permite que el bucket S3 invoque la función Lambda al detectar un evento.

*Notificación de eventos en S3 (aws_s3_bucket_notification.bucket_notification):
  Configura para que cuando se suba un objeto (s3:ObjectCreated:*), se dispare automáticamente la función Lambda.

------Intruciones de Despliegue-----------------------

Instrucciones de Despliegue para Integración S3 -> Lambda
Configurar las credenciales de AWS (AWS CLI o variables de entorno).

*Empaqueta código Lambda en un archivo .zip llamado lambda_function_payload.zip y se agrega en la raíz.
 zip lambda_function_payload.zip index.py

*Desde la carpeta terraform/, inicializa Terraform:
 terraform init

*Aplica los cambios:
 terraform apply

#Confirma los cambios escribiendo YES cuando Terraform lo solicite.

*Resultado esperado:
  Se creará un bucket S3.
  Se desplegará una función Lambda.
  Al subir un archivo al bucket, se disparará automáticamente la función Lambda.


Sección 4: Escenarios Prácticos (40 puntos)

*Serverless API en AWS

  Esta solución implementa una arquitectura serverless utilizando AWS y Terraform:

  API Gateway con endpoint expuesto /register
  Lambda Function en Python/Node.js que almacena datos en DynamoDB
  CloudWatch Logs habilitado y alarmas básicas por errores
  Optimización de costos ajustando:

  *Lambda Function - Registro en DynamoDB
  
  Esta Lambda recibe datos vía API Gateway y guarda registros en DynamoDB.

  ##  Descripción

  - Lenguaje: **Python 3.9**
  - Frameworks/librerías usadas: **boto3** (cliente AWS SDK para Python)
  - La función espera un evento de tipo **API Gateway proxy**.
  - El payload debe contener al menos:
  - `user_id`: Identificador único del usuario
  - `name`: Nombre del usuario
  - Si falta alguno de los campos requeridos, responde con **400 Bad Request**.
  - Si el proceso es exitoso, inserta los datos en DynamoDB y devuelve **201 Created**.

------Intruciones de Despliegue-----------------------

  # 1. Cambiar al directorio de Terraform
  cd terraform/
 
  # 2. Inicializar Terraform
  terraform init

  # 3. Aplicar la infraestructura
  terraform apply

  # 4. Confirmar escribiendo 'yes' cuando se solicite
  Una vez completado, se mostrará en la salida la URL del API Gateway para consumir el endpoint /register.

*Pipeline CI/CD - GitHub Actions

  Trigger automático en push a la rama main
  
  Jobs configurados para:
  Instalar Terraform
  Inicializar Terraform
  Planificar despliegue
  Aplicar cambios automáticamente

*Archivo importante:
  .github/workflows/deploy.yml


*Estrategias de Minimización de Costos

  Función Lambda configurada con:
  Memoria mínima necesaria (128MB por defecto)
  Timeout de ejecución ajustado (5s por defecto)
  Uso de DynamoDB en modo on-demand para evitar pagos por capacidad provisionada innecesaria.











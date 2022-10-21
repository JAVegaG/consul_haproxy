# MicroProyecto 1 Computación en la Nube (especialización IA)

En este proyecto se implementará un service mesh con la ayuda de Hashicorp Consul. Una vez implementado el cluster deberá correr agentes cónsul en al menos dos nodos, cada uno de los cuales alojará una aplicación web. Se requiere además implementar balanceo de carga con la ayuda de [HAProxy](http://www.haproxy.org/). Los clientes enviarán peticiones al balanceador de carga HAProxy y obtendrán respuestas desde dos servidores web. La configuración requerida se muestra en la siguiente figura.

<div align="center">
  <img alt="Shows the system architecture." src="/images/arch.png">
</div>

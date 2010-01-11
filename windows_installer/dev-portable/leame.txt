W3AF Portable
----------------

Pasos para preparar w3af portable.

1) Python
Descargar Python 2.5.4 e instalalor
http://www.python.org/ftp/python/2.5.4/python-2.5.4.msi

2) Pre-requisitos
Ejecutar "install_prerequisite.bat"

3) Python + Pre-requisitos
Editar el archivo "copy_python.bat" con los directorios correctos
Ejecutar "copy_python.bat"

4) Graphviz
Instalar Graphviz2.20 normalmente en "c:\Archivos de programa"
Editar el archivo "copy_graphiz2.20.bat" con los directorios correctos
Ejecutar "copy_graphiz2.20.bat"

5) Svn client
Tomar el svn-client que se encuentra en el svn oficial de w3af.
Editar el archivo "copy_svn-client.bat" con los directorios correctos
Ejecutar "copy_svn-client.bat"

6) W3af
Traer del repositorio de svn el trunk de w3af USANDO el cliente de svn de w3af.
No usar el tortoise-svn ya que puede ser una version diferente al del svn-client y luego
el svn-client dice que es "very old"
Editar el archivo "copy_w3af.bat" con los directorios correctos
Ejecutar "copy_w3af.bat"

7) Armar w3af portable
Una vez que se tiene todo el entorno armado, ahora vamos a armar la version portable.
Editar el archivo "armar_w3af_portable.bat" con los directorios correctos
Ejecutar "armar_w3af_portable.bat"

8) Finalizado
Ejecutar el archivo "w3af_gui.bat" y verificar que funciona.
Compilar el windows installer



//3D
///Arreglos de de datos tipo boolean para las 3 dimensiones 
boolean[] bx = {
  false, true, false, true, false, true, false, true
};
boolean[] by = {
  false, false, true, true, false, false, true, true
};
boolean[] bz = {
  false, false, false, false, true, true, true, true
};

float rx, ry;

//CLASE OCTREE
//La clase octree tiene su propia función draw()
class Octree {
  
  Table dataTable;
  float columna1 = 0;
  //valor maximo y minimo de la columna 3 del archivo
  float dataMinColumna1 = 0;
  float dataMaxColumna1 = 0;
 
  float columna2 = 0;
  float columna4 = 0;
  boolean hasChilds;
  Octree[] childs;
  color c;
  PVector p;
  //Vector tridimensional  PVector ejemplo = new PVector(x, y, z);
  //"Vista"
  PVector o = new PVector(0, 0, 0);
  //Vector tridimensional  cuyas coordenadas en x, y, z están dadas por un número generado al azar entre -1 y 1
  PVector v = new PVector(random(-1,1),random(-1,1),random(-1,1));
  float s;
  int my_level;
  //Función
  Octree(float is, PVector ip, boolean haveChilds, int level) {
    s = is;
    p = ip;
    hasChilds = haveChilds;
    my_level = level;
    //Si tiene hijos
    if ( hasChilds ) {
      //Crear un arreglo de tipo Octree con 8 posiciones
      childs = new Octree[2];
      float half_s = s/2;
      //Se recorre el arreglo 
      for (int i=0; i<2; i++) {        
        //En cada iteración se inserta un Octree
        childs[i] = new Octree(
        half_s, 
        new PVector(
        
        // x = valor de x de ip + (Si es true el valor de x es la mitad de s y si es falso es 0)  variable = (condición)?valor1:valor2;
        // y = valor de y de ip + (Si es true el valor de y es la mitad de s y si es falso es 0)  variable = (condición)?valor1:valor2;
        // z = valor de z de ip + (Si es true el valor de z es la mitad de s y si es falso es 0)  variable = (condición)?valor1:valor2;
        p.x+(bx[i]?half_s:0), 
        p.y+(by[i]?half_s:0), 
        p.z+(bz[i]?half_s:0)
          ), 
        //true or false dependiendo de si my_level es menor que tres y si el número generado aleatroriamente en menor que 0.6
        my_level < 2 && random(1) < .6, 
        my_level+1
          );
      }
    } 
    //Si no tiene hijos 
    else {
      //float r = random(255);
      //c = color(r, r, random(r, 255));
      //generar un color al azar 
      c = color(random(255), random(255), random(255));
    }
  }
  void draw() {
    if ( hasChilds ) {
      for (int i=0; i<2; i++) {
        childs[i].draw();
        obtenerTabla();
      }
    } else {
      fill(c);
      noStroke();
      //      stroke(c);
      //      noFill();
      //Solo esta parte del código
      pushMatrix();
      
      //translate(x,y,z);
      translate(p.x+o.x, p.y+o.y, p.z+o.z);
      translate(s/2, s/2, s/2);
      //box() --- cubos. box(size) . Revisar documentación de P3D
      //Valor absoluto de (-100000 + residuo entre cantidad de mil inicio programa/200000)
      box(s*map(abs(-10000+millis()%20000), 0, 10000, .3, 1));
      popMatrix();
      //Si el mouse está presionado 
      if (lock){ //mousePressed) {
        o.x=.9*o.x;
        o.y=.9*o.y;
        o.z=.9*o.z;
      } else {
        o.x+=v.x;//random(-10,10);
        o.y+=v.y;//random(-10,10);
        o.z+=v.z;//random(-10,10);
      }
    }
  }
  
  void obtenerTabla(){
    dataTable = loadTable("CalidadAire.tsv");
 
    // da el numero de filas del archivo
    rowCount = dataTable.getRowCount();
    //"Hay x cantidad de filas"
    println("Hay un total de " + rowCount + " filas");
   
  }
}



///2D

//Crea una tabla que guarda los datos del archivo .tsv
Table dataTable;
PFont miTitulo;
PFont etiquetas;
//numero de filas en el archivo
int rowCount;
Octree ot;
float mx, my;
boolean lock = false;

//diametro de la elipse
float tamano = 35;

//segundo
//guarda el valor de la columna 1
float columna1 = 0;
//valor maximo y minimo de la columna 3 del archivo
float dataMinColumna1 = 0;
float dataMaxColumna1 = 0;
float columna4 = 0;
 float dataMinColumna4 = 0;
  float dataMaxColumna4 = 0;
float columna2 = 0;
float columna3 = 0;

//tercero
//se utiliza para dar el color segun el valor de la columna 1
float aproxColor = 0;
//da el color a cada circulo
color colorIntermedio;

//quinto
//guarda el nombre de la fila
String nombreAnio;

void setup() 
{
  //Tamaño de lienzo x,y
  size(1280, 700, P3D);  
  miTitulo = loadFont("Catamaran-Bold-32.vlw");
  etiquetas = loadFont("Archivo-Regular-16.vlw");
  
  
   //traer datos de la carpeta data
  dataTable = loadTable("CalidadAire.tsv");
 
  // da el numero de filas del archivo
  rowCount = dataTable.getRowCount();
  //"Hay x cantidad de filas"
  println("Hay un total de " + rowCount + " filas");
  
  //recorre el archivo 
  for (int i = 0; i < rowCount; i++) 
   {
    
    //segundo
    columna1 = dataTable.getFloat(i, 1); // columna 1
    //determina el valor max y minimo de la columna 3   
    if (columna1 > dataMaxColumna1) 
    {
      dataMaxColumna1 = columna1;
    }
    if (columna1 < dataMinColumna1) 
    {
      dataMinColumna1 = columna1;
    }
    
    columna4 = dataTable.getFloat(i, 4); // columna 1
    //determina el valor max y minimo de la columna 3   
    if (columna4 > dataMaxColumna4) 
    {
      dataMaxColumna4 = columna4;
    }
    if (columna4 < dataMinColumna4) 
    {
      dataMinColumna4 = columna4;
    }
    
   }
  
}

void draw() 
{  
  //Cambiar color de fondo 
  background(0);
  //insertar y ubicar imagen 
  fill(255);
  textFont(miTitulo, 32);
  textAlign(BOTTOM);
  text("Percepción VS Realidad",100, 124);

  
  // Loop through the rows of the locations file and draw the points  
  for (int i = 0; i < rowCount; i++) 
  {
    //Posición de los circulos 
   // x = dataTable.getFloat(i, 1);  // column 1
    //y = dataTable.getFloat(i, 2);  // column 2
    
    //segundo
    columna1 = dataTable.getFloat(i, 1);  // column 4
    columna4 = dataTable.getFloat(i, 4); 
    //Hayar nuevo valor entre 0 y 1 para representar color
    aproxColor = map(columna4, dataMinColumna4, dataMaxColumna4, 0, 1);
    colorIntermedio = lerpColor(#7af24e, #f2564e, aproxColor);
     noStroke();
     
     lights();
   
    //map(variableAModificar, minOriginal, maxOriginal, minAsignado, maxAsignado
    tamano = map(columna1, dataMinColumna1, dataMaxColumna1, 10, 150);
    columna2 = dataTable.getFloat(i, 2);
    int profundidad = -100;
    int y = 400;
    if (i<=4){
    profundidad = -300;
    y = 300;
    }
   
    //Hayar nuevo valor entre 0 y 1 para representar color
    //aproxColor = map(columna1, dataMinColumna4, dataMaxColumna4, 0, 1);
    //DEFINICIÓN TAMAÑO CUBO
    rx+=40;
    pushMatrix();
    translate(columna2, y, profundidad);
    translate(20, 100, 200);
    //posicion x, posicion y, alto y ancho
    fill(colorIntermedio);
    box(columna1);
    println("");
    popMatrix();
    
    //quinto
    //Seleccionar un String de determinada fila y columna
    nombreAnio = dataTable.getString(i,0);
    //Calcula distancia entre dos puntos, en este caso determina
    //si el mouse está sobre el círculo. 
   if (dist(columna2, y, profundidad, mouseX, mouseY, profundidad) < tamano) 
    {
      fill(0);
      textFont(etiquetas, 14);
      textAlign(CENTER);
      // Show the data value and the state abbreviation in parentheses
      //text("palabra", x, y)
      fill(255);
      text("Estación Sevillana - "+nombreAnio,columna2, 400);
      text("PM10" + ":" + columna1,columna2,420);
    }
  }
  pushMatrix();
  fill(255);
  lights();
  translate(600, 700, -100);
  box(1000, 100, 500);
  popMatrix();
  
  if (dist(600, 700, -100, mouseX, mouseY, -100) < 1000) 
    {
      fill(0);
      textFont(etiquetas, 14);
      textAlign(CENTER);
      // Show the data value and the state abbreviation in parentheses
      //text("palabra", x, y)
      fill(255);
      text("El 45% de los bogotanos consideran a la",600, 630);
      text("mala calidad del aire el mayor problema de la ciudad", 600,650);
    }
}

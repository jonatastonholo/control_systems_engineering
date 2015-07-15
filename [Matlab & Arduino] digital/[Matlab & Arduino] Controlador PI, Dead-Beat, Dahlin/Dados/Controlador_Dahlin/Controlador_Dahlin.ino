 /* ----- Controlador proporcional e integral para o sistema termico ----- */
 
 
// const int Referencia = 0; // O sinal de referencia sera lido a partir do pino de 
                          // entrada analogica A0

const int Ref = 0;      // Referencia sera conectado ao pino de entrada analogica A0   
const int Sensor1 = 1; // O sensor sera conectado ao pino de entrada analogica A1
const int Sensor2 = 2; // O sensor sera conectado ao pino de entrada analogica A2

const int Atuador = 5; // O sinal de comando "analogico" (saida do controlador) 
                       // sera transmitido pelo pino de saida digital 5 (PWM)

double Valor_Referencia;
double Valor_Sensor1; // Variavel que armazenara o valor da saida (tensao no capacitor 1)
double Valor_Sensor2; // Variavel que armazenara o valor da saida (tensao no capacitor 2)

double Valor_Atuador; // Variavel que armazenara o valor da 
                   // saida do controlador (acao de controle)

double D; 
double k1 = -2.2361;
double k2 = 2.5920; 


double Erro; // Variavel que armazenara o sinal de erro (Valor_referencia - Valor_Sensor)

const double T = 0.00664; // Tempo de amostragem em milissegundos
double ck=0;  //c(k)
double ck1=0; //c(k-1)
double ck2=0; //c(k-2)

double ek=0;  //e(k)
double ek1=0; //e(k-1)
double ek2=0; //e(k-2)

double last_time;
void setup(){
  
Serial.begin(9600); // Especifique a velocidade da comunicacao serial

Serial.println("\nErro\tVc1\tVc2\tAtuador");     
Serial.println("---------------------------");     

pinMode(Ref, INPUT); // Define o pino do sensor como uma entrada
pinMode(Sensor1, INPUT); // Define o pino do sensor como uma entrada
pinMode(Sensor2, INPUT); // Define o pino do sensor como uma entrada

pinMode(Atuador, OUTPUT); // Define o pino do atuador como uma saida

last_time = millis();
}



void loop(){  

  
  Valor_Sensor1 = analogRead(Sensor1); // Converte o valor de tensao numa palavra binaria de 10 bits (0V a 5V <---> 0 a 1023)

  Valor_Sensor1 = Valor_Sensor1/1023*5; // Mapeia de 10 bits para um escala de 0 a 5 V

  Valor_Sensor2 = analogRead(Sensor2); // Converte o valor de tensao numa palavra binaria de 10 bits (0V a 5V <---> 0 a 1023)

  Valor_Sensor2 = Valor_Sensor2/1023*5; // Mapeia de 10 bits para um escala de 0 a 5 V
  
  Valor_Referencia = analogRead(Ref); // Converte o valor de tensao numa palavra binaria de 10 bits (0V a 5V <---> 0 a 1023)

  Valor_Referencia = Valor_Referencia/1023*5; // Mapeia de 10 bits para um escala de 0 a 5 V

  D = k1*Valor_Sensor1 + k2*Valor_Sensor2; // EXPRESSAO DO CONTROLADOR

 if ((millis() - last_time) > 1000*T) {

  last_time = millis();   
  
  Erro = (Valor_Referencia - Valor_Sensor2);
  Erro = Erro*(255/5); // Mapeia de uma escala de 0 a 5 V para 8 bits 
  
  ek2 = ek1;
  ek1 = ek;    
  ek = Erro;
  
  ck2 = ck1;
  ck1 = ck;    
  
  ck = 0.074242981308880*ck1 + 0.925757018691120*ck2 +   1.035588322898393*ek - 1.744865183567332*ek1 +   0.822341931913884*ek2;
                                            
  Valor_Atuador = constrain(ck, 0, 255); // Restringe o valor do sinal de atuacao
                                            // a faixa de 0V a 5V (0 a 255)
  
  analogWrite(Atuador, Valor_Atuador); // Escreve no pino 5 (Atuador), que simulara
  /*                                     // uma saida analogica via PWM 
  Serial.print("Erro: ");                                                       
  Serial.print(Erro);
  Serial.print("\tVc1: ");                                                       
  Serial.print(Valor_Sensor1);
  Serial.print("\tVc2: "); 
  Serial.print(Valor_Sensor2);
  Serial.print("\tAtuador: "); 
  Serial.println(Valor_Atuador);  
  //delay(100); */
  }
 
}  
    

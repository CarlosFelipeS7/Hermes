/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Ex2;

/**
 *
 * @author ccfel
 */
public class Tabuada {
    private int mult;
    
    public String Tabuada(int mult){
        this.mult=mult;
        
        for(int i = 1; i<=10; i++){
            
            
            System.out.println( mult + " X " + i + " = " + mult*i  
            
            );
        
        }
        
        return " ";
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package Ex2;

import java.util.Scanner;

/**
 *
 * @author ccfel
 */
public class Principal {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Scanner ler = new Scanner(System.in);
        Tabuada tabuada = new Tabuada(); 
        
        System.out.println("Informe o numero que deseja ver a tabuada: ");
        int mult = ler.nextInt();
        
        System.out.println(tabuada.Tabuada(mult));
        
    }
    
}

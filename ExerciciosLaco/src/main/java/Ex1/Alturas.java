/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Ex1;

import java.util.Scanner;

/**
 *
 * @author ccfel
 */
public class Alturas {
    private double idade;
    private double total;
    private double idadeacima;

    Scanner ler = new Scanner(System.in);
    
    public void Alturas(double idade){
         this.idade=idade;
         
         this.total=this.idade;
         
         if(this.idade > 50){
             
             this.idadeacima++;
                 
         }          
    }
    
    private double Media(){
        return this.total / 20;
    }

    public String mostrar_Info(){
        return "A media das pessoas com + de 50 anos: " + this.Media() +
                "\n A quantidade de pessoas com mais de 50 anos " + this.idadeacima;
    }

}
  
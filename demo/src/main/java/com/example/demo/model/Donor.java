package com.example.demo.model;

import jakarta.persistence.Entity;  // Changed from Date to LocalDateTime
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "donor")
public class Donor {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;               
    private String name;          
    private int age;             
    private String gender;     
    private String bloodGroup;  
    private String phone;        
    private String city;       

}
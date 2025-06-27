package com.example.demo.model;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Donor {
    @Id @GeneratedValue
    private Long id;
    @OneToMany(mappedBy = "donor", cascade = CascadeType.ALL, orphanRemoval = true)
@JsonManagedReference
private List<Donation> donations;


    private String name;
    private int age;
    private String gender;
    private String bloodGroup;
    private String phone;
    private String city;
    private LocalDate lastDonation;
}

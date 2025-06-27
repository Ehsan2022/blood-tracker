package com.example.demo.model;

import jakarta.persistence.CascadeType;

public @interface OneToMany {

    public String mappedBy();

    public CascadeType cascade();

    public boolean orphanRemoval();

}

package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.Donor;
import com.example.demo.repository.DonorRepository;

@RestController
@RequestMapping("/api/donors")
@CrossOrigin
public class DonorController {

    @Autowired 
    private DonorRepository repo;

    @GetMapping
    public List<Donor> getAllDonors() {
        return repo.findAll();
    }

    @PostMapping
    public ResponseEntity<Donor> create(@RequestBody Donor donor) {
            System.out.println("Received donor: " + donor.toString()); 
            Donor savedDonor = repo.save(donor);
            return ResponseEntity.ok(savedDonor);

    }

    @PutMapping("/{id}")
    public Donor update(@PathVariable Long id, @RequestBody Donor donor) {
        donor.setId(id);
        return repo.save(donor);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        repo.deleteById(id);
    }
}

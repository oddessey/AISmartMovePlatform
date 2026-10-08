
package com.smartmove.domain.user.entity;

import jakarta.persistence.*;
import lombok.*;
import org.locationtech.jts.geom.Point;

@Entity
@Getter @Setter @Builder
@NoArgsConstructor @AllArgsConstructor
public class Engineer {
    @Id
    private Long userId; // User.id FK

    private Double rating;
    private Integer careerYears;
    private Boolean hasLadder;
    private Boolean hasWeldingTool;
    private Boolean isAvailable;

    // PostGIS 위치 - SRID 4326 (WGS84)
    @Column(columnDefinition = "geometry(Point,4326)")
    private Point location;

    private Double lat;
    private Double lng;
}

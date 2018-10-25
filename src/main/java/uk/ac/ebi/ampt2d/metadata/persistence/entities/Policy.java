/*
 *
 * Copyright 2018 EMBL - European Bioinformatics Institute
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package uk.ac.ebi.ampt2d.metadata.persistence.entities;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.annotations.ApiModelProperty;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.List;

@Entity
public class Policy extends Auditable<AccessionVersionEntityId>  {

    @ApiModelProperty(position = 1, required = true)
    @Valid
    @EmbeddedId
    private AccessionVersionEntityId id;

    @ApiModelProperty(position = 2)
    @Size(min = 1, max = 255)
    @JsonProperty
    @Column
    private String title;

    @ApiModelProperty(position = 3, required = true)
    @Size(min = 1, max = 255)
    @NotNull
    @JsonProperty
    @Column(nullable = false)
    private String center;

    @ApiModelProperty(position = 4, dataType = "java.lang.String", notes = "Policy text or file")
    @Size(min = 1, max = 255)
    @JsonProperty
    @Column
    private String content;

    @ApiModelProperty(position = 5, dataType = "java.lang.String", notes = "Url to a DAC")
    @JsonProperty
    @ManyToOne(optional = false)
    private Dac dac;

    @ApiModelProperty(position = 6, dataType = "java.lang.List", notes = "Urls to data use conditions")
    @JsonProperty
    @OneToMany
    private List<Duo> dataUseConditions;

    @OneToMany
    private List<WebResource> resources;

    public AccessionVersionEntityId getId() {
        return id;
    }
}

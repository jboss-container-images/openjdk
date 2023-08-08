#!/usr/bin/python3

# generate ImageStream metadata

# inputs:
#   data.yaml: data on versions and exceptions
#   templates/*: Jinja-format template snippets

from jinja2 import Environment, FileSystemLoader, select_autoescape
import yaml

# fetch a key from a nested dict
def fetch(obj, path, k):
    # traverse the dicts to find the one nested at path
    o = obj
    for i in range(0, len(path)):
        o = o[path[i]]

    # if they key isn't present at this level, try the parent
    if not k in o.keys() and path:
        return fetch(obj, path[:-1], k)
    return o.get(k)

def renderTags(os,
               jdkVersion,
               data,
               variant='builder', # or runtime
               imageTags=False,
               supports=False,
               arch=False,
               sampleRepo=True,
               description=False,
               displayName=False,
              ):

    path = [os, variant, jdkVersion]
    if fetch(data, path, arch):
        path.append(arch)

    name = fetch(data, path, 'name') or "{}/openjdk-{}".format(os, jdkVersion)
    from_= fetch(data, path, 'from')
    to_  = fetch(data, path, 'to')
    not_ = fetch(data, path, 'not') or []

    return ",\n".join([ tag.render(
        version="1.{}".format(v),
        tag="1.{}".format(v),
        rhel=os,
        openjdk=jdkVersion,
        containerName=name,
        tags=imageTags,
        supports=supports,
        sampleRepo=sampleRepo,
        description=description,
        displayName=displayName,
        )
        for v in range(from_, to_+1)
        if v not in not_
    ])

def renderImageStream(os,
                      nameFn=lambda os,v: "{}-openjdk-{}".format(os,v),
                      variant='builder',
                      displayNameFn=lambda v: False,

                      # the following flags are passed through to renderTags
                      imageTags=False,
                      sampleRepo=True,
                      descriptionFn=lambda v: False,
                     ):
    return ",\n".join([ imagestream.render(
        rhel=os,
        name=nameFn(os,v),
        openjdk=v,
        displayName=displayNameFn(v),
        tags=renderTags(
             os,
             v,
             data,
             variant=variant,
             imageTags=imageTags,
             sampleRepo=sampleRepo,
             displayName=displayNameFn(v),
             description=descriptionFn(v),
        ))
        for v in [8,11,17]
   ])

##############################################################################

env = Environment(
    loader = FileSystemLoader("templates"),
    autoescape=select_autoescape()
)

template    = env.get_template("template.jinja")
imagestream = env.get_template("imagestream.jinja")
tag         = env.get_template("tag.jinja")

data  = yaml.safe_load(open("data.yaml"))
ubi8  = data['ubi8']
rhel7 = data['rhel7']

with open("community-image-streams.json","w") as fh:
    fh.write(template.render(
        rhel="ubi8",
        items=renderImageStream("ubi8")+","+
            env.get_template("community-javaImageStream.jinja").render()
    ))

with open("image-streams.json","w") as fh:
    fh.write(template.render(
        rhel="",
        description="ImageStream definition for Red Hat OpenJDK.",
        name="openjdk18-image-stream",
        items=",".join([
            imagestream.render(
                rhel="rhel7",
                name="redhat-openjdk18-openshift",
                openjdk="8",
                tags=renderTags("rhel7", 8, data,
                imageTags="builder,java,openjdk,hidden",
                supports="java:8",),
            ),
            imagestream.render(
                rhel="rhel7",
                name="openjdk-11-rhel7",
                openjdk="11",
                tags=renderTags("rhel7", 11, data,
                    imageTags="builder,java,openjdk,hidden",
                    supports="java:11",),
            ),
            renderImageStream("ubi8", imageTags="builder,java,openjdk,ubi8,hidden"),
            env.get_template("javaImageStream.jinja").render()
        ])
    ))

with open("image-streams-aarch64.json", "w") as fh:
    fh.write(template.render(
        rhel="ubi8",
        name="openjdk18-image-stream",
        items=",".join([
            renderImageStream("ubi8", imageTags="builder,java,openjdk,ubi8,hidden"),
            env.get_template("community-javaImageStream.jinja").render()
        ])
    ))

with open("image-streams-ppc64le.json", "w") as fh:
    fh.write(template.render(
        rhel="",
        description="ImageStream definition for Red Hat OpenJDK.",
        name="openjdk18-image-stream",
        items=",".join([
            imagestream.render(
                rhel="rhel7",
                name="redhat-openjdk18-openshift",
                openjdk="8",
                tags=renderTags("rhel7", 8, data,
                imageTags="builder,java,openjdk,hidden",
                supports="java:8", arch="ppc64le"),
            ),
            imagestream.render(
                rhel="rhel7",
                name="openjdk-11-rhel7",
                openjdk="11",
                tags=renderTags("rhel7", 11, data,
                    imageTags="builder,java,openjdk,hidden",
                    supports="java:11",),
            ),
            renderImageStream("ubi8", imageTags="builder,java,openjdk,ubi8,hidden"),
            env.get_template("javaImageStream.jinja").render()
        ])
    ))

with open("image-streams-s390x.json", "w") as fh:
    fh.write(template.render(
        rhel="",
        description="ImageStream definition for Red Hat OpenJDK.",
        name="openjdk18-image-stream",
        items=",".join([
            imagestream.render(
                rhel="rhel7",
                name="redhat-openjdk18-openshift",
                openjdk="8",
                tags=renderTags("rhel7", 8, data,
                imageTags="builder,java,openjdk,hidden",
                supports="java:8", arch="s390x"),
            ),
            imagestream.render(
                rhel="rhel7",
                name="openjdk-11-rhel7",
                openjdk="11",
                tags=renderTags("rhel7", 11, data,
                    imageTags="builder,java,openjdk,hidden",
                    supports="java:11",),
            ),
            renderImageStream("ubi8", imageTags="builder,java,openjdk,ubi8,hidden"),
            env.get_template("javaImageStream.jinja").render()
        ])
    ))

with open("runtime-image-streams.json", "w") as fh:
    fh.write(template.render(
        rhel="ubi8",
        name="ubi8-openjdk-runtime-image-stream",
        description="ImageStream definition for Red Hat UBI8 OpenJDK Runtimes.",
        items=",".join([
            renderImageStream(
                "ubi8",
                variant="runtime",
                nameFn=lambda o,v: "{}-openjdk-{}-runtime".format(o,v),
                displayNameFn=lambda v: "Red Hat OpenJDK {} Runtime (UBI8)".format(v),
                imageTags="java,openjdk,ubi8",
                sampleRepo=False,
                descriptionFn=lambda v: "Run Java applications using OpenJDK {} upon UBI8.".format(v),
            ),
            env.get_template("java-runtimeImageStream.jinja").render()
        ])
    ))
